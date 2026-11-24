import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/core/api/sse.dart';

Stream<String> _frames(List<String> frames) async* {
  for (final f in frames) {
    yield f;
  }
}

String _sse(String data, {String comment = ''}) =>
    '${comment.isEmpty ? '' : ': $comment\n'}data: $data\n\n';

Map<String, Object?> _m(List<Object?> events, int i) =>
    events[i]! as Map<String, Object?>;

void main() {
  group('parseSseStream', () {
    test('разбирает одиночный фрейм', () async {
      final events = await parseSseStream(
        _bytes(_frames([_sse('{"type":"x"}')])),
      ).toList();
      expect(events, hasLength(1));
      expect(_m(events, 0)['type'], 'x');
    });

    test('игнорирует keep-alive комментарии', () async {
      final events = await parseSseStream(
        _bytes(_frames([_sse('{"a":1}', comment: 'ping')])),
      ).toList();
      expect(events, hasLength(1));
    });

    test('многострочный data склеивается', () async {
      const frames = 'data: {"a":\ndata: 1}\n\n';
      final events = await parseSseStream(_bytes(_frames([frames]))).toList();
      expect(events, hasLength(1));
      expect(_m(events, 0)['a'], 1);
    });

    test('несколько фреймов в одном чанке', () async {
      const frames = 'data: {"n":1}\n\ndata: {"n":2}\n\ndata: {"n":3}\n\n';
      final events = await parseSseStream(_bytes(_frames([frames]))).toList();
      expect(events, hasLength(3));
    });

    test('битый JSON не роняет поток', () async {
      final events = await parseSseStream(
        _bytes(_frames([_sse('{oops'), _sse('{"ok":1}')])),
      ).toList();
      expect(events, hasLength(2));
      expect(events[0], isNull);
      expect(_m(events, 1)['ok'], 1);
    });

    test('фрейм без пустой строки в конце всё равно отдаётся', () async {
      const frames = 'data: {"tail":true}\n';
      final events = await parseSseStream(_bytes(_frames([frames]))).toList();
      expect(events, hasLength(1));
      expect(_m(events, 0)['tail'], isTrue);
    });

    test('чанкование посреди фрейма не ломает парсер', () async {
      const frame = 'data: {"split":true}\n\n';
      final events = await parseSseStream(_splitBytes(frame)).toList();
      expect(events, hasLength(1));
      expect(_m(events, 0)['split'], isTrue);
    });
  });

  test('SSE переподключается после тишины на открытом HTTP-потоке', () async {
    final adapter = _QuietAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1'))
      ..httpClientAdapter = adapter;
    final client = SseClient(
      dio: dio,
      path: '/api/event',
      idleTimeout: const Duration(milliseconds: 25),
      maxBackoffMs: 2,
    );
    addTearDown(client.close);
    final event = await client.stream().first.timeout(
      const Duration(seconds: 2),
    );
    expect(event, {'type': 'server.connected'});
    expect(adapter.requests, 2);
    expect(adapter.quiet.hasListener, isFalse);
  });
}

Stream<List<int>> _bytes(Stream<String> lines) async* {
  await for (final line in lines) {
    yield line.codeUnits;
  }
}

Stream<List<int>> _splitBytes(String s) async* {
  final bytes = s.codeUnits;
  for (var i = 0; i < bytes.length; i += 3) {
    final end = i + 3 > bytes.length ? bytes.length : i + 3;
    yield bytes.sublist(i, end);
  }
}

class _QuietAdapter implements HttpClientAdapter {
  int requests = 0;
  final quiet = StreamController<Uint8List>();

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (++requests == 1) return ResponseBody(quiet.stream, 200);
    return ResponseBody.fromString(_sse('{"type":"server.connected"}'), 200);
  }
}
