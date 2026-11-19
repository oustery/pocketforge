@Tags(['integration'])
library;

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/core/api/opencode_client.dart';

/// Интеграционные тесты против реального opencode serve.
///
/// Запуск:
///   LIVE_BASE_URL=http://127.0.0.1:PORT LIVE_PASSWORD=... \
///     flutter test --tags integration
/// Без переменных окружения тесты пропускаются.
void main() {
  final baseUrl = Platform.environment['LIVE_BASE_URL'];
  final password = Platform.environment['LIVE_PASSWORD'];
  final live = baseUrl != null &&
      baseUrl.isNotEmpty &&
      password != null &&
      password.isNotEmpty;

  late OpenCodeClient client;

  setUpAll(() {
    if (!live) return;
    client = OpenCodeClient(baseUrl: baseUrl, password: password);
  });

  test(
    'health: isHealthy() == true',
    () async {
      expect(await client.isHealthy(), isTrue);
    },
    skip: !live,
  );

  test(
    'config: список провайдеров не пуст',
    () async {
      final r = await client.configProviders();
      expect(r.providers, isNotEmpty);
    },
    skip: !live,
  );

  test(
    'session: create → list → delete',
    () async {
      final s = await client.sessionCreate();
      expect(s.id, startsWith('ses_'));
      final list = await client.sessionList();
      expect(list.any((e) => e.id == s.id), isTrue);
      final deleted = await client.sessionDelete(sessionID: s.id);
      expect(deleted, isTrue);
    },
    skip: !live,
  );

  test(
    'sse: первый event приходит в течение 10 секунд',
    () async {
      final events = client.events(autoReconnect: false);
      final first = await events.first.timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('SSE не отдал событие'),
      );
      expect(first, isNotNull);
    },
    skip: !live,
  );

  test(
    'auth: методы провайдера + authSet/authRemove roundtrip',
    () async {
      // Список методов (на «голом» сервере может быть пустой map).
      final res = await client.dio.get<Object?>('/provider/auth');
      expect(res.data, isA<Map<String, Object?>>());
      // Roundtrip экспорта oauth-токена в песочницу.
      final set = await client.authSet(
        providerID: 'github',
        body: {
          'type': 'oauth',
          'refresh': '',
          'access': 'gho_integration_test_token',
          'expires': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
          'accountId': 'pf-it',
        },
      );
      expect(set, isTrue);
      final removed = await client.authRemove(providerID: 'github');
      expect(removed, isTrue);
    },
    skip: !live,
  );

  test(
    'chat: sessionMessages/permissionList/questionList читаются',
    () async {
      final s = await client.sessionCreate();
      final messages = await client.sessionMessages(sessionID: s.id);
      expect(messages, isA<List<Object?>>());
      final perms = await client.permissionList();
      expect(perms, isA<List<Object?>>());
      final questions = await client.questionList();
      expect(questions, isA<List<Object?>>());
      // Interrupt по неактивной сессии не должен падать.
      await client.v2SessionInterrupt(sessionID: s.id);
      await client.sessionDelete(sessionID: s.id);
    },
    skip: !live,
  );

  test(
    'pty: shells доступны; create зависит от окружения песочницы',
    () async {
      final shells = await client.ptyShells();
      expect(shells, isNotEmpty);
      // В PoC-песочнице (proot x86_64) bun/node-pty не находит tty-символы
      // (M.symbols) — сервер отвечает 500. На реальном Android arm64
      // /dev/ptmx доступен и создание проходит. Проверяем оба исхода:
      try {
        final pty = await client.ptyCreate(body: {});
        expect(pty.id, isNotEmpty);
        await client.ptyRemove(ptyID: pty.id);
      } on DioException catch (e) {
        // допускаем только известное средовое ограничение
        expect(e.response?.statusCode, 500);
      }
    },
    skip: !live,
  );
}
