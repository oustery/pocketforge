import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/// Разбор Server-Sent Events поверх байтового потока dio.
///
/// Формат: строки `data: <json>`, пустая строка — конец события;
/// комментарии (`: ping`) и поля event/id/retry игнорируются.
/// Каждый фрейм opencode — JSON варианта union (Event / V2Event),
/// поэтому отдаём распарсенный объект через диспетчеризацию в фасаде.
Stream<Object?> parseSseStream(Stream<List<int>> bytes) async* {
  var dataLines = <String>[];
  // Dio exposes a reified Stream<Uint8List>; widen the event type before
  // attaching the decoder, which accepts StreamTransformer<List<int>, ...>.
  final lines = bytes
      .map<List<int>>((chunk) => chunk)
      .transform(const Utf8Decoder(allowMalformed: true))
      .transform(const LineSplitter());
  await for (final line in lines) {
    if (line.isEmpty) {
      if (dataLines.isNotEmpty) {
        yield _decodeEvent(dataLines.join('\n'));
        dataLines = <String>[];
      }
      continue;
    }
    if (line.startsWith(':')) continue; // keep-alive
    if (line.startsWith('data:')) {
      var value = line.substring(5);
      if (value.startsWith(' ')) value = value.substring(1);
      dataLines.add(value);
    }
    // event:/id:/retry: — не используются opencode, игнорируем
  }
  if (dataLines.isNotEmpty) {
    yield _decodeEvent(dataLines.join('\n'));
  }
}

Object? _decodeEvent(String raw) {
  try {
    final json = jsonDecode(raw);
    if (json is Map<String, Object?>) {
      // локальный импорт невозможен (circular) — диспетчеризация в фасаде;
      // здесь отдаём сырой JSON события, а типизация происходит выше.
      return json;
    }
    return null;
  } on FormatException {
    return null;
  }
}

/// SSE-подключение к opencode serve с автопереподключением.
class SseClient {
  /// Создаёт клиент SSE.
  SseClient({
    required this.dio,
    required this.path,
    this.maxBackoffMs = 15000,
    this.idleTimeout = const Duration(seconds: 90),
  }) : assert(maxBackoffMs > 0, 'maxBackoffMs must be positive');

  /// Настроенный dio (с Basic-интерсептором).
  final Dio dio;

  /// Путь SSE-эндпоинта (обычно `/api/event`).
  final String path;

  /// Верхняя граница backoff между переподключениями.
  final int maxBackoffMs;

  /// Максимальная пауза между порциями байтов, включая keep-alive.
  final Duration idleTimeout;

  final _stops = <void Function()>{};
  bool _closed = false;

  /// Подключается при первом прослушивании и восстанавливает соединение
  /// после разрыва, если [reconnect] включён.
  Stream<Object?> stream({bool reconnect = true}) {
    late StreamController<Object?> controller;
    CancelToken? request;
    var stopped = false;
    StreamSubscription<Object?>? sub;
    Completer<void>? wake;
    Timer? timer;
    var backoff = 1000.clamp(1, maxBackoffMs);

    void resume() {
      final pending = wake;
      if (pending != null && !pending.isCompleted) pending.complete();
    }

    void stop() {
      stopped = true;
      request?.cancel();
      timer?.cancel();
      unawaited(sub?.cancel());
      resume();
    }

    Future<void> run() async {
      _stops.add(stop);
      try {
        while (!_closed && !stopped) {
          final token = request = CancelToken();
          try {
            final response = await dio.get<ResponseBody>(
              path,
              cancelToken: token,
              options: Options(
                responseType: ResponseType.stream,
                receiveTimeout: idleTimeout,
                receiveDataWhenStatusError: false,
                headers: {'Accept': 'text/event-stream'},
              ),
            );
            final body = response.data;
            if (token.isCancelled) {
              await body?.stream.listen((_) {}).cancel();
              break;
            }
            if (body != null) {
              final finished = wake = Completer<void>();
              sub = parseSseStream(body.stream).listen(
                (event) {
                  if (event != null) backoff = 1000.clamp(1, maxBackoffMs);
                  if (!token.isCancelled) controller.add(event);
                },
                onDone: resume,
                onError: (Object _) => resume(),
                cancelOnError: true,
              );
              await finished.future;
            }
          } on DioException {
            // HTTP ошибки и обрывы обрабатываются общим backoff ниже.
          } finally {
            token.cancel();
            await sub?.cancel();
            request = null;
            sub = null;
          }
          if (!reconnect || _closed || stopped) break;
          final delay = wake = Completer<void>();
          timer = Timer(Duration(milliseconds: backoff), resume);
          backoff = (backoff * 2).clamp(1, maxBackoffMs);
          await delay.future;
        }
      } finally {
        _stops.remove(stop);
        unawaited(controller.close());
      }
    }

    controller = StreamController<Object?>(onListen: run, onCancel: stop);
    return controller.stream;
  }

  /// Закрывает активные подключения и отменяет запланированные повторы.
  void close() {
    _closed = true;
    for (final stop in _stops.toList()) {
      stop();
    }
  }
}
