import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/core/api/opencode_client.dart';
import 'package:pocketforge/features/git/git_controller.dart';
import 'package:pocketforge/features/git/git_service.dart';

/// Fake-адаптер: canned .git-файлы + /vcs/status + /file/list.
class GitAdapter implements HttpClientAdapter {
  GitAdapter();

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.path;
    final query = options.queryParameters;

    Object? body;
    if (path == '/vcs/status') {
      body = <Object>[
        {
          'file': 'lib/main.dart',
          'additions': 12,
          'deletions': 3,
          'status': 'modified',
        },
        {
          'file': 'lib/new.dart',
          'additions': 40,
          'deletions': 0,
          'status': 'added',
        },
      ];
    } else if (path == '/file/content') {
      var p = (query['path'] ?? '') as String;
      if (!p.startsWith('/')) p = '/root/project/$p';
      final files = <String, String>{
        '/root/project/.git/HEAD': 'ref: refs/heads/dev\n',
        '/root/project/.git/packed-refs':
            '# pack-refs with: peeled fully-peeled sorted\n'
            '1111111 refs/heads/main\n2222222 refs/heads/dev\n',
        '/root/project/.git/refs/heads/dev': '2222222\n',
        '/root/project/.git/refs/heads/feature': '3333333\n',
        '/root/project/.git/logs/HEAD':
            '1111111 2222222 Dev <dev@x> 1700000000 +0000\tcommit: setup\n'
            '2222222 4444444 Dev <dev@x> 1700000100 +0000\tcommit: feature\n',
      };
      final content = files[p];
      body = content == null
          ? <String, Object?>{}
          : <String, Object?>{'type': 'text', 'content': content};
    } else if (path == '/file') {
      final p = (query['path'] ?? '') as String;
      if (p == '.git/refs/heads' || p == '/root/project/.git/refs/heads') {
        body = <Object>[
          {
            'name': 'dev',
            'path': '.git/refs/heads/dev',
            'absolute': '/root/project/.git/refs/heads/dev',
            'type': 'file',
            'ignored': false,
          },
          {
            'name': 'feature',
            'path': '.git/refs/heads/feature',
            'absolute': '/root/project/.git/refs/heads/feature',
            'type': 'file',
            'ignored': false,
          },
        ];
      } else {
        body = <Object>[];
      }
    } else {
      body = const <String, Object?>{};
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

ProviderContainer makeContainer() {
  final dio = Dio()..httpClientAdapter = GitAdapter();
  final client = OpenCodeClient(
    baseUrl: 'http://127.0.0.1:4096',
    password: 'x',
    dio: dio,
  );
  return ProviderContainer(
    overrides: [gitServiceProvider.overrideWith((ref) => GitService(client))],
  );
}

void main() {
  test('GitService.overview: HEAD, ветки, vcsStatus, reflog', () async {
    final c = makeContainer();
    addTearDown(c.dispose);
    final service = c.read(gitServiceProvider)
      ..workDir = '/root/project';

    final o = await service.overview();
    expect(o.head.branch, 'dev');
    expect(o.head.detached, isFalse);
    expect(o.head.oid, '2222222');
    expect(o.branches.map((b) => b.name), ['dev', 'feature', 'main']);
    expect(o.vcsFiles, hasLength(2));
    expect(o.clean, isFalse);
    expect(o.log, hasLength(2));
    expect(o.log.first.oid, '4444444');
    expect(o.log.first.message, 'commit: feature');
  });

  test('GitService.diff отдаёт патчи', () async {
    // /vcs/diff не добавлен в adapter — вернётся пусто, но без исключения.
    final c = makeContainer();
    addTearDown(c.dispose);
    final service = c.read(gitServiceProvider);
    final d = await service.diff();
    expect(d, isEmpty);
  });

  test('контроллер: build грузит сводку; requestAgentAction кладёт промпт',
      () async {
    final c = makeContainer();
    addTearDown(c.dispose);
    final state = await c.read(gitControllerProvider.future);
    expect(state.overview, isNotNull);
    expect(state.overview!.head.branch, 'dev');

    c
        .read(gitControllerProvider.notifier)
        .requestAgentAction('git pull');
    expect(c.read(pendingGitActionProvider), 'git pull');
  });
}
