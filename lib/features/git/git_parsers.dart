import 'package:flutter/foundation.dart';

/// Текущая ветка из `.git/HEAD`.
@immutable
class GitHeadInfo {
  /// Создаёт описание.
  const GitHeadInfo({
    required this.branch,
    required this.oid,
    required this.detached,
  });

  /// Разбор содержимого HEAD: 'ref: refs/heads/main' или oid.
  factory GitHeadInfo.parse(String content, String oid) {
    final text = content.trim();
    if (text.startsWith('ref:')) {
      final ref = text.substring(4).trim();
      return GitHeadInfo(
        branch: ref.replaceFirst('refs/heads/', ''),
        oid: oid,
        detached: false,
      );
    }
    return GitHeadInfo(branch: '', oid: text, detached: true);
  }

  /// Имя ветки (пусто в detached).
  final String branch;

  /// Текущий oid (из HEAD или resolved ref).
  final String oid;

  /// Detached HEAD.
  final bool detached;
}

/// Ветка из refs.
@immutable
class GitBranch {
  /// Создаёт ветку.
  const GitBranch({
    required this.name,
    required this.oid,
    required this.current,
  });

  /// Пустая ветка (для orElse).
  static const GitBranch empty = GitBranch(name: '', oid: '', current: false);

  /// Имя ветки (short refname).
  final String name;

  /// oid.
  final String oid;

  /// Текущая ветка.
  final bool current;
}

/// Запись истории (reflog `.git/logs/HEAD`).
@immutable
class GitLogEntry {
  /// Создаёт запись.
  const GitLogEntry({
    required this.oid,
    required this.author,
    required this.timestamp,
    required this.message,
  });

  /// oid коммита (new в reflog).
  final String oid;

  /// Автор.
  final String author;

  /// Unix-время (сек).
  final int timestamp;

  /// Сообщение reflog-действия (commit: ... / clone: from ...).
  final String message;

  /// Человекочитаемая дата.
  String get date =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true)
          .toIso8601String();
}

/// Разбор `.git/HEAD`: ('ref: refs/heads/main' | oid).
(String, bool) parseHead(String content) {
  final text = content.trim();
  if (text.startsWith('ref:')) {
    return (text.substring(4).trim(), false);
  }
  return (text, true);
}

/// Разбор `.git/packed-refs`:
/// Формат строки: oid refname; #-комментарии и peeled (^) пропускаются.
Map<String, String> parsePackedRefs(String content) {
  final result = <String, String>{};
  for (final line in content.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#') || trimmed.startsWith('^')) {
      continue;
    }
    final space = trimmed.indexOf(' ');
    if (space <= 0) continue;
    result[trimmed.substring(space + 1).trim()] = trimmed.substring(0, space);
  }
  return result;
}

/// Разбор `.git/logs/HEAD`.
List<GitLogEntry> parseReflog(String content, {int limit = 50}) {
  final entries = <GitLogEntry>[];
  for (final line in content.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;
    // Формат: old new Name email ts tz [TAB] message
    final tab = trimmed.indexOf('\t');
    final head = tab >= 0 ? trimmed.substring(0, tab) : trimmed;
    final message = tab >= 0 ? trimmed.substring(tab + 1) : '';
    final parts = head
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.length < 6) continue;
    // Разбор с конца: tz, ts, email (<...>), имя — всё остальное.
    final tz = parts.last;
    final ts = int.tryParse(parts[parts.length - 2]) ?? 0;
    var emailIdx = -1;
    for (var i = parts.length - 3; i >= 2; i--) {
      if (parts[i].startsWith('<') && parts[i].endsWith('>')) {
        emailIdx = i;
        break;
      }
    }
    if (emailIdx < 0 || ts == 0) continue;
    final name = parts.sublist(2, emailIdx).join(' ');
    entries.add(
      GitLogEntry(
        oid: parts[1],
        author: '$name ${parts[emailIdx]} $tz',
        timestamp: ts,
        message: message,
      ),
    );
  }
  if (entries.length > limit) {
    return entries.sublist(entries.length - limit).reversed.toList();
  }
  return entries.reversed.toList();
}

/// Имена loose-веток (fileList .git/refs/heads) — относительные пути.
List<GitBranch> mergeBranches({
  required List<GitBranch> loose,
  required Map<String, String> packed,
  required String headRef,
}) {
  final result = <String, GitBranch>{};
  packed.forEach((ref, oid) {
    if (!ref.startsWith('refs/heads/')) return;
    final name = ref.substring('refs/heads/'.length);
    result[name] = GitBranch(name: name, oid: oid, current: ref == headRef);
  });
  for (final b in loose) {
    final ref = 'refs/heads/${b.name}';
    result[b.name] = GitBranch(
      name: b.name,
      oid: b.oid,
      current: ref == headRef || b.current,
    );
  }
  final names = result.keys.toList()..sort();
  return [for (final n in names) result[n]!];
}
