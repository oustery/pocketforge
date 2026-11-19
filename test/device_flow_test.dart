import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/features/auth/device_flow.dart';

/// Fake-adapter GitHub Device Flow.
class FakeFlowAdapter implements HttpClientAdapter {
  FakeFlowAdapter(this.steps);

  /// Последовательность ответов на /access_token.
  final List<Map<String, Object?>> steps;
  int _index = 0;

  int get index => _index;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.uri.path.endsWith('/device/code')) {
      return _json(<String, Object?>{
        'device_code': 'dev_123',
        'user_code': 'ABCD-1234',
        'verification_uri': 'https://github.com/login/device',
        'expires_in': 900,
        'interval': 5,
      });
    }
    final step = steps[min(_index, steps.length - 1)];
    _index++;
    return _json(step);
  }

  ResponseBody _json(Map<String, Object?> body) => ResponseBody.fromString(
        jsonEncode(body),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
}

void main() {
  const config = DeviceFlowConfig(clientId: 'test_client');

  Future<GitHubDeviceFlow> flow(FakeFlowAdapter adapter) async {
    final dio = Dio()..httpClientAdapter = adapter;
    return GitHubDeviceFlow(
      dio: dio,
      config: config,
      sleep: (_) async {},
    );
  }

  group('GitHubDeviceFlow', () {
    test('requestCode парсит код устройства', () async {
      final adapter = FakeFlowAdapter([]);
      final f = await flow(adapter);
      final code = await f.requestCode();
      expect(code.deviceCode, 'dev_123');
      expect(code.userCode, 'ABCD-1234');
      expect(code.verificationUri, 'https://github.com/login/device');
      expect(code.interval, 5);
    });

    test('poll: pending → slow_down → success', () async {
      final adapter = FakeFlowAdapter([
        {'error': 'authorization_pending'},
        {'error': 'slow_down'},
        {
          'access_token': 'gho_token',
          'token_type': 'bearer',
          'scope': 'repo',
        },
      ]);
      final f = await flow(adapter);
      final code = await f.requestCode();
      var waits = 0;
      final result = await f.poll(
        code,
        onWait: (_, _) => waits++,
      );
      expect(result.accessToken, 'gho_token');
      expect(adapter.index, 3);
      expect(waits, 2);
    });

    test('poll: expired_token бросает DeviceFlowException', () async {
      final adapter = FakeFlowAdapter([
        {'error': 'authorization_pending'},
        {'error': 'expired_token'},
      ]);
      final f = await flow(adapter);
      final code = await f.requestCode();
      await expectLater(
        f.poll(code),
        throwsA(
          isA<DeviceFlowException>()
              .having((e) => e.code, 'code', 'expired_token'),
        ),
      );
    });

    test('poll: slow_down увеличивает интервал на 5 с', () async {
      final adapter = FakeFlowAdapter([
        {'error': 'slow_down'},
        {
          'access_token': 'tok',
          'token_type': 'bearer',
          'scope': '',
        },
      ]);
      final dio = Dio()..httpClientAdapter = adapter;
      final f = GitHubDeviceFlow(
        dio: dio,
        config: config,
        sleep: (d) async {
          // базовый интервал 5 с, после slow_down — 10 с
          expect(d.inSeconds, 10);
        },
      );
      final code = await f.requestCode();
      await f.poll(code);
    });
  });
}
