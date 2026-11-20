import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/core/api/opencode_client.dart';
import 'package:pocketforge/features/auth/auth_controller.dart';
import 'package:pocketforge/features/auth/token_store.dart';

class ScriptedAdapter implements HttpClientAdapter {
  ScriptedAdapter();

  final List<RequestOptions> calls = [];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options);
    final path = options.path;
    final method = options.method;

    Object? body = const <String, Object?>{};
    if (path == '/provider/auth') {
      body = {
        'anthropic': <Object>[
          <String, Object?>{
            'type': 'oauth',
            'label': 'OAuth (Claude Pro / Max)',
            'prompts': [],
          },
          <String, Object?>{
            'type': 'api',
            'label': 'API key',
            'prompts': <Object>[],
          },
        ],
      };
    } else if (path == '/provider/anthropic/oauth/authorize' &&
        method == 'POST') {
      body = {
        'url': 'https://claude.ai/oauth/authorize?code_challenge=abc',
        'method': 'code',
        'instructions': 'Откройте ссылку, подтвердите и вставьте код',
      };
    } else if (path == '/provider/anthropic/oauth/callback' ||
        path.startsWith('/auth/')) {
      body = true;
    }
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

void main() {
  ProviderContainer container(ScriptedAdapter adapter) {
    final dio = Dio()..httpClientAdapter = adapter;
    final client = OpenCodeClient(
      baseUrl: 'http://127.0.0.1:4096',
      password: 'x',
      dio: dio,
    );
    return ProviderContainer(
      overrides: [
        authClientProvider.overrideWithValue(client),
        tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      ],
    );
  }

  test('loadMethods: методы провайдера из /provider/auth', () async {
    final adapter = ScriptedAdapter();
    final c = container(adapter);
    addTearDown(c.dispose);

    await c.read(authControllerProvider.notifier).loadMethods('anthropic');
    final s = c.read(authControllerProvider).value!;
    expect(s.methods, hasLength(2));
    expect(s.methods[0].type, 'oauth');
    expect(s.methods[1].type, 'api');
  });

  test('startOauth: authorize → waitingCode + url + инструкция', () async {
    final adapter = ScriptedAdapter();
    final c = container(adapter);
    addTearDown(c.dispose);
    final ctrl = c.read(authControllerProvider.notifier);
    await ctrl.loadMethods('anthropic');

    await ctrl.startOauth('anthropic', methodIndex: 0);
    final s = c.read(authControllerProvider).value!;
    expect(s.phase, AuthUiPhase.waitingCode);
    expect(s.methodIsCode, isTrue);
    expect(s.authorizeUrl, contains('oauth/authorize'));
    expect(s.instructions, contains('код'));
  });

  test('finishWithCode: callback → done; экспорт токена через authSet',
      () async {
    final adapter = ScriptedAdapter();
    final c = container(adapter);
    addTearDown(c.dispose);
    final ctrl = c.read(authControllerProvider.notifier);
    await ctrl.loadMethods('anthropic');
    await ctrl.startOauth('anthropic', methodIndex: 0);

    await ctrl.finishWithCode('anthropic', 'the_code');
    final s = c.read(authControllerProvider).value!;
    expect(s.phase, AuthUiPhase.done);
    expect(s.authenticatedProvider, 'anthropic');

    final put = adapter.calls
        .where((x) => x.method == 'PUT' && x.path == '/auth/anthropic')
        .toList();
    expect(put, isEmpty); // server-side oauth: PUT /auth не используется

    final callback = adapter.calls
        .where(
          (x) =>
              x.method == 'POST' &&
              x.path == '/provider/anthropic/oauth/callback',
        )
        .toList();
    expect(callback, hasLength(1));
  });

  test('finishWithDeviceFlowToken: PUT /auth/{id} c oauth-телом', () async {
    final adapter = ScriptedAdapter();
    final c = container(adapter);
    addTearDown(c.dispose);

    await c
        .read(authControllerProvider.notifier)
        .finishWithDeviceFlowToken('github', 'gho_x');
    final s = c.read(authControllerProvider).value!;
    expect(s.phase, AuthUiPhase.done);

    final put = adapter.calls
        .where((x) => x.method == 'PUT' && x.path == '/auth/github')
        .toList();
    expect(put, hasLength(1));
    final body = (put.first.data as Map).cast<String, Object?>();
    expect(body['type'], 'oauth');
    expect(body['access'], 'gho_x');
  });

  test('revoke: DELETE /auth/{id}', () async {
    final adapter = ScriptedAdapter();
    final c = container(adapter);
    addTearDown(c.dispose);

    await c.read(authControllerProvider.notifier).revoke('anthropic');
    final delete = adapter.calls
        .where((x) => x.method == 'DELETE' && x.path == '/auth/anthropic')
        .toList();
    expect(delete, hasLength(1));
  });
}
