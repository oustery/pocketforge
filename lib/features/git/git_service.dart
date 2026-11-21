import 'package:flutter/foundation.dart';

import 'package:pocketforge/core/api/models.gen.dart';

import 'package:pocketforge/core/api/opencode_client.dart';

import 'package:pocketforge/features/git/git_parsers.dart';

/// Сводка git-состояния репозитория (read-only, без pty).
@immutable
class GitOverview {
  /// Создаёт сводку.
  const GitOverview({
    required this.head,
    required this.branches,
    required this.vcsFiles,
    required this.log,
  });

  /// Текущая ветка.
  final GitHeadInfo head;

  /// Локальные ветки (loose + packed).
  final List<GitBranch> branches;

  /// Статусы файлов от нативного /vcs/status.
  final List<VcsFileStatus> vcsFiles;

  /// История из reflog (свежие сверху).
  final List<GitLogEntry> log;

  /// Чистое ли рабочее дерево.
  bool get clean => vcsFiles.isEmpty;
}

/// Git-интеграция через opencode serve:
/// - статус/дифф — нативные `/vcs/status`, `/vcs/diff`;
/// - ветки/история — чтение `.git` через file API (HEAD, refs,
///   packed-refs, logs/HEAD);
/// - мутации (clone/pull/push/checkout) — через git-агента в сессии чата
///   (pty-эндпоинт opencode тянет node-pty под libc песочницы: в Alpine/musl
///   он был недоступен; на Debian ограничение снялось бы, но путь не
///   проверен, поэтому exec-команд в API нет).
class GitService {
  /// Создаёт сервис. [workDir] — репозиторий внутри песочницы.
  GitService(this.client, {this.workDir = '/root/project'});

  /// Клиент opencode.
  final OpenCodeClient client;

  /// Каталог репозитория (в песочнице).
  String workDir;

  Future<String?> _readText(String path) async {
    try {
      final fc = await client.fileRead(path: '$workDir/$path');
      return fc.type == 'text' ? fc.content : null;
    } on Exception {
      return null;
    }
  }

  /// Читает refs: HEAD + loose + packed.
  Future<(GitHeadInfo, List<GitBranch>)> refs() async {
    final headText = await _readText('.git/HEAD') ?? '';
    final headRef = headText.startsWith('ref:')
        ? headText.substring(4).trim()
        : '';

    // Loose refs: fileList(.git/refs/heads).
    final loose = <GitBranch>[];
    try {
      final nodes = await client.fileList(path: '$workDir/.git/refs/heads');
      for (final n in nodes) {
        if (n.type != 'file') continue;
        final abs = n.absolute;
        final repoPrefix = '$workDir/.git/';
        final rel = abs.startsWith(repoPrefix)
            ? abs.substring(repoPrefix.length)
            : (abs.startsWith('.git/')
                ? abs.replaceFirst('.git/', '')
                : 'refs/heads/$abs');
        final content = await _readText(n.path);
        final oid = content?.trim() ?? '';
        if (oid.isEmpty) continue;
        loose.add(
          GitBranch(
            name: rel.replaceFirst('refs/heads/', ''),
            oid: oid,
            current: rel == headRef,
          ),
        );
      }
    } on Exception {
      // refs/heads может отсутствовать (пустой репозиторий).
    }

    final packedText = await _readText('.git/packed-refs') ?? '';
    final packed = parsePackedRefs(packedText);

    // oid текущей ветки: из ref'а (loose/packed) либо сам HEAD.
    var oid = '';
    if (headRef.isNotEmpty) {
      oid = loose
              .firstWhere(
                (b) => 'refs/heads/${b.name}' == headRef,
                orElse: () => GitBranch.empty,
              )
              .oid;
      if (oid.isEmpty) oid = packed[headRef] ?? '';
    }
    final headText2 =
        headText.startsWith('ref:') ? '' : headText.trim();
    final head = GitHeadInfo.parse(
      headText,
      headText2.isNotEmpty ? headText2 : oid,
    );

    final merged = mergeBranches(
      loose: loose,
      packed: packed,
      headRef: headRef,
    );
    return (head, merged);
  }

  /// Полная сводка.
  Future<GitOverview> overview({int logCount = 50}) async {
    final (head, branches) = await refs();

    List<VcsFileStatus> vcsFiles;
    try {
      // Без directory: serve запущен с cwd = workDir (иначе opencode
      // поднимает второй инстанс и зависает в песочнице).
      vcsFiles = await client.vcsStatus();
    } on Exception {
      vcsFiles = const <VcsFileStatus>[];
    }

    final reflogText = await _readText('.git/logs/HEAD') ?? '';
    final log = parseReflog(reflogText, limit: logCount);

    return GitOverview(
      head: head,
      branches: branches,
      vcsFiles: vcsFiles,
      log: log,
    );
  }

  /// Дифф (patch) изменённых файлов.
  Future<List<VcsFileDiff>> diff() async {
    try {
      return await client.vcsDiff(mode: 'git');
    } on Exception {
      return const <VcsFileDiff>[];
    }
  }

  /// Промпт git-агенту: клонирование репозитория.
  String promptClone(String url) =>
      'Склонируй репозиторий $url в /root и покажи итог: список файлов '
      'верхнего уровня и текущую ветку.';

  /// Промпт git-агенту: pull.
  String promptPull() =>
      'В репозитории $workDir выполни `git pull --autostash` и покажи вывод. '
      'Если конфликты — опиши файлы с конфликтами.';

  /// Промпт git-агенту: push.
  String promptPush() =>
      'В репозитории $workDir выполни `git push` и покажи вывод '
      '(если upstream не задан — предложи команду с --set-upstream).';

  /// Промпт git-агенту: смена ветки.
  String promptCheckout(String branch) =>
      'В репозитории $workDir выполни `git checkout $branch` и покажи '
      'результат (текущая ветка и статус).';

  /// Промпт git-агенту: коммит.
  String promptCommit(String message) =>
      'В репозитории $workDir сделай коммит всех изменений с сообщением '
      '"$message" и покажи вывод git commit.';
}
