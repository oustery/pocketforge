import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/core/api/opencode_client.dart';

class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.responder);

  final List<RequestOptions> calls = [];
  final ResponseBody Function(RequestOptions options) responder;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options);
    return responder(options);
  }
}

void main() {
  group('OpenCodeClient (unit, fake adapter)', () {
    test('Basic-заголовок добавляется на каждый запрос', () async {
      final adapter = FakeAdapter(
        (options) => ResponseBody.fromString(
          jsonEncode({'healthy': true}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );
      final dio = Dio()..httpClientAdapter = adapter;
      final client = OpenCodeClient(
        baseUrl: 'http://127.0.0.1:4096',
        password: 'secret',
        dio: dio,
      );
      final ok = await client.isHealthy();
      expect(ok, isTrue);
      expect(adapter.calls, hasLength(1));
      final auth = adapter.calls[0].headers['Authorization'] as String;
      expect(auth, startsWith('Basic '));
      expect(
        utf8.decode(base64Decode(auth.substring(6))),
        'opencode:secret',
      );
      expect(adapter.calls[0].uri.toString(), 'http://127.0.0.1:4096/api/health');
    });

    test('authRemove парсит bool из plain-ответа', () async {
      final adapter = FakeAdapter(
        (options) => ResponseBody.fromString('true', 200),
      );
      final dio = Dio()..httpClientAdapter = adapter;
      final client = OpenCodeClient(
        baseUrl: 'http://127.0.0.1:4096',
        password: 'x',
        dio: dio,
      );
      final ok = await client.authRemove(providerID: 'opencode');
      expect(ok, isTrue);
      expect(adapter.calls[0].path, '/auth/opencode');
      expect(adapter.calls[0].method, 'DELETE');
    });

    test('sessionList разбирает List<Session>', () async {
      final session = jsonEncode({
        'id': 'ses_test',
        'slug': 'test',
        'projectID': 'proj',
        'directory': '/root',
        'title': 'Тестовая сессия',
        'version': '1.19.6',
        'time': {'created': 1, 'updated': 2},
      });
      final adapter = FakeAdapter(
        (options) => ResponseBody.fromString(
          '[$session]',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );
      final dio = Dio()..httpClientAdapter = adapter;
      final client = OpenCodeClient(
        baseUrl: 'http://127.0.0.1:4096',
        password: 'x',
        dio: dio,
      );
      final list = await client.sessionList();
      expect(list, hasLength(1));
      expect(list[0].id, 'ses_test');
      expect(list[0].title, 'Тестовая сессия');
    });

    test('sessionCreate отправляет POST на /session', () async {
      final session = jsonEncode({
        'id': 'ses_new',
        'slug': 'new',
        'projectID': 'proj',
        'directory': '/root',
        'title': 'Новая',
        'version': '1.19.6',
        'time': {'created': 1, 'updated': 2},
      });
      final adapter = FakeAdapter(
        (options) => ResponseBody.fromString(
          session,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );
      final dio = Dio()..httpClientAdapter = adapter;
      final client = OpenCodeClient(
        baseUrl: 'http://127.0.0.1:4096',
        password: 'x',
        dio: dio,
      );
      final s = await client.sessionCreate();
      expect(s.id, 'ses_new');
      expect(adapter.calls[0].method, 'POST');
      expect(adapter.calls[0].uri.toString(), contains('/session'));
    });
  });

  group('ApiException', () {
    test('форматирует сообщение от DioException', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/api/health'),
        type: DioExceptionType.connectionError,
        message: 'refused',
      );
      final api = ApiException.fromDio(err);
      expect(api.statusCode, -1);
      expect(api.message, 'Нет соединения с serve');
      expect(api.toString(), contains('/api/health'));
    });
  });
}
