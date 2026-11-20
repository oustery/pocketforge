import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:pocketforge/core/api/client.gen.dart';
import 'package:pocketforge/core/api/models.gen.dart';
import 'package:pocketforge/core/api/sse.dart';

/// Ошибка HTTP-вызова opencode serve с человеческим описанием.
class ApiException implements Exception {
  /// Создаёт ошибку.
  ApiException({
    required this.statusCode,
    required this.method,
    required this.path,
    this.message,
  });

  /// Из [DioException] (dio сам различает таймауты/сеть/HTTP-коды).
  factory ApiException.fromDio(DioException e) {
    final opts = e.requestOptions;
    final status = e.response?.statusCode ?? -1;
    String? message;
    final data = e.response?.data;
    if (data is Map) {
      final err = data['error'] ?? data['message'];
      if (err is String) message = err;
    }
    message ??= switch (e.type) {
      DioExceptionType.connectionTimeout => 'Таймаут подключения',
      DioExceptionType.receiveTimeout => 'Таймаут ответа',
      DioExceptionType.connectionError => 'Нет соединения с serve',
      _ => e.message ?? 'HTTP $status',
    };
    return ApiException(
      statusCode: status,
      method: opts.method,
      path: opts.path,
      message: message,
    );
  }

  /// HTTP-код ответа (-1 — сетевая ошибка).
  final int statusCode;

  /// HTTP-метод запроса.
  final String method;

  /// Путь запроса.
  final String path;

  /// Текст ошибки (из тела или типа исключения).
  final String? message;

  @override
  String toString() => 'ApiException($method $path → $statusCode): $message';
}

/// Клиент opencode serve: типизированные операции + SSE-подписка.
///
/// Все запросы идут на `http://127.0.0.1:<port>` с Basic-паролем,
/// сгенерированным при запуске песочницы.
class OpenCodeClient extends OpenCodeApiGen {
  /// Создаёт клиент: настраивает [Dio] c Basic-авторизацией.
  factory OpenCodeClient({
    required String baseUrl,
    required String password,
    Dio? dio,
  }) {
    final d = configure(dio ?? Dio(), baseUrl: baseUrl, password: password);
    return OpenCodeClient._(d);
  }

  OpenCodeClient._(this.dio) : super(dio);

  /// Настроенный [Dio] (используется и для SSE).
  final Dio dio;

  /// Настраивает dio: базовый URL, таймауты, Basic-интерсептор.
  static Dio configure(
    Dio dio, {
    required String baseUrl,
    required String password,
  }) {
    dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 5)
      ..receiveTimeout = const Duration(minutes: 5)
      ..sendTimeout = const Duration(seconds: 30);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final raw = utf8.encode('opencode:$password');
          options.headers['Authorization'] =
              'Basic ${base64Encode(raw)}';
          handler.next(options);
        },
      ),
    );
    return dio;
  }

  /// Строка Basic-авторизации (для WebSocket-подключений).
  String basicAuthValue(String password) =>
      'Basic ${base64Encode(utf8.encode('opencode:$password'))}';

  /// Живой ли сервер: GET /api/health → {healthy: true}.
  Future<bool> isHealthy() async {
    final r = await v2HealthGet();
    return r.healthy;
  }

  /// SSE-поток событий с автопереподключением.
  ///
  /// Один долговечный `GET /api/event`; при разрыве — экспоненциальный
  /// backoff (1 c → 15 c максимум). Каждый фрейм диспетчеризуется
  /// в типизированный вариант события ([V2Event.fromJson]).
  Stream<Object?> events({bool autoReconnect = true}) {
    final sse = SseClient(dio: dio, path: '/api/event');
    return sse
        .stream(reconnect: autoReconnect)
        .map((frame) {
          if (frame is Map<String, Object?>) {
            return V2Event.fromJson(frame);
          }
          return frame;
        })
        .where((e) => e != null);
  }

  /// Поток сырых SSE-фреймов (Map) — для чата, где нужна толерантность
  /// к v1/v2-формам обёртки события.
  Stream<Map<String, Object?>> eventsRaw({bool autoReconnect = true}) {
    final sse = SseClient(dio: dio, path: '/api/event');
    return sse
        .stream(reconnect: autoReconnect)
        .where((e) => e is Map<String, Object?>)
        .cast<Map<String, Object?>>();
  }
}
