import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

/// Разбор Server-Sent Events поверх байтового потока dio.
///
/// Формат: строки `data: <json>`, пустая строка — конец события;
/// комментарии (`: ping`) и поля event/id/retry игнорируются.
/// Каждый фрейм opencode — JSON варианта union (Event / V2Event),
/// поэтому отдаём распарсенный объект через диспетчеризацию в фасаде.
Stream<Object?> parseSseStream(Stream<List<int>> bytes) async* {
  var dataLines = <String>[];
  await for (final line in _toLines(bytes)) {
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

Stream<String> _toLines(Stream<List<int>> bytes) async* {
  final buffer = <int>[];
  await for (final chunk in bytes) {
    buffer.addAll(chunk);
    while (true) {
      final idx = buffer.indexOf(10); // \n
      if (idx < 0) break;
      var line = utf8.decode(buffer.sublist(0, idx), allowMalformed: true);
      if (line.endsWith('\r')) line = line.substring(0, line.length - 1);
      yield line;
      buffer.removeRange(0, idx + 1);
    }
  }
  if (buffer.isNotEmpty) {
    yield utf8.decode(buffer, allowMalformed: true);
  }
}

/// SSE-подключение к opencode serve с автопереподключением.
class SseClient {
  /// Создаёт клиент SSE.
  SseClient({required this.dio, required this.path, this.maxBackoffMs = 15000});

  /// Настроенный dio (с Basic-интерсептором).
  final Dio dio;

  /// Путь SSE-эндпоинта (обычно `/api/event`).
  final String path;

  /// Верхняя граница backoff между переподключениями.
  final int maxBackoffMs;

  bool _closed = false;

  /// Поток событий. Подключается при первом прослушивании; при разрыве
  /// восстанавливает соединение (если [reconnect]).
  ///
  /// Устойчивость на мобильных сетях: backoff сбрасывается только после
  /// реального события (crash-loop сервера больше не превращается в
  /// шторм переподключений), а при 90 с полной тишины соединение
  /// считается мёртвым и переподключается (half-open TCP после сна
  /// модема иначе висит вечно без событий).
  Stream<Object?> stream({bool reconnect = true}) {
    late StreamController<Object?> controller;
    StreamSubscription<Object?>? sub;
    Completer<void>? active;
    Timer? watchdog;
    var attempt = 0;

    void armWatchdog() {
      watchdog?.cancel();
      watchdog = Timer(const Duration(seconds: 90), () {
        // Тишина: рвём зависшее соединение — onDone уведёт цикл в backoff.
        unawaited(sub?.cancel());
      });
    }

    Future<void> run() async {
      while (!_closed) {
        try {
          final res = await dio.get<ResponseBody>(
            path,
            options: Options(
              responseType: ResponseType.stream,
              headers: {'Accept': 'text/event-stream'},
            ),
          );
          if (_closed) {
            // Отмена пришла, пока ждали GET: тело не слушаем, соединение
            // закрываем (иначе HTTP-стрим утекает до закрытия сервером).
            final body = res.data;
            if (body != null) {
              await body.stream
                  .listen((_) {}, cancelOnError: true)
                  .cancel()
                  .timeout(const Duration(seconds: 5), onTimeout: () {});
            }
            break;
          }
          final completer = Completer<void>();
          active = completer;
          sub = parseSseStream(res.data!.stream).listen(
            (event) {
              // Сброс backoff только после живого события: успешный GET
              // ещё не гарантирует работающий стрим.
              attempt = 0;
              armWatchdog();
              controller.add(event);
            },
            onDone: () {
              if (!completer.isCompleted) completer.complete();
            },
            onError: (Object e) {
              if (!completer.isCompleted) completer.completeError(e);
            },
            cancelOnError: true,
          );
          armWatchdog();
          await completer.future;
        } on Exception {
          if (_closed) break;
          // разрыв/таймаут — уходим в backoff
        }
        watchdog?.cancel();
        unawaited(sub?.cancel());
        sub = null;
        active = null;
        if (!reconnect || _closed) break;
        final delayMs = min(maxBackoffMs, 1000 * pow(2, attempt++).toInt());
        try {
          await Future<void>.delayed(Duration(milliseconds: delayMs));
        } on Exception {
          break;
        }
      }
      watchdog?.cancel();
      await controller.close();
    }

    controller = StreamController<Object?>(
      onListen: run,
      onCancel: () {
        _closed = true;
        watchdog?.cancel();
        unawaited(sub?.cancel());
        final a = active;
        if (a != null && !a.isCompleted) a.complete();
      },
    );
    return controller.stream;
  }

  /// Закрывает клиент: дальнейшие переподключения прекращаются.
  void close() {
    _closed = true;
  }
}
