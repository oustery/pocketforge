import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/features/git/git_controller.dart';
import 'package:pocketforge/features/git/git_parsers.dart';

/// Экран git-интеграции: ветка, изменения, история; мутации — через
/// git-агента (переносит промпт в чат-сессию).
class GitPage extends ConsumerWidget {
  /// Создаёт страницу git.
  const GitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gitControllerProvider);
    final ctrl = ref.read(gitControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Git', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
            onPressed: ctrl.refresh,
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Каталог репозитория',
            onPressed: () => _workDirDialog(context, ctrl, state.value),
          ),
          PopupMenuButton<String>(
            tooltip: 'Git-действия (через агента)',
            onSelected: (v) => switch (v) {
              'clone' => _cloneDialog(context, ctrl),
              'commit' => _commitDialog(context, ctrl),
              'pull' => unawaited(_runAgent(context, ctrl, ctrl.pullPrompt())),
              'push' => unawaited(_runAgent(context, ctrl, ctrl.pushPrompt())),
              'diff' => ctrl.loadDiff(),
              'branches' => _branchesSheet(context, ctrl, state.value),
              _ => null,
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'clone', child: Text('Клонировать…')),
              PopupMenuItem(value: 'commit', child: Text('Коммит…')),
              PopupMenuItem(value: 'pull', child: Text('Pull (агент)')),
              PopupMenuItem(value: 'push', child: Text('Push (агент)')),
              PopupMenuItem(value: 'diff', child: Text('Показать diff')),
              PopupMenuItem(value: 'branches', child: Text('Ветки…')),
            ],
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (s) => RefreshIndicator(
          onRefresh: ctrl.refresh,
          child: _GitBody(state: s, ctrl: ctrl),
        ),
      ),
    );
  }

  Future<void> _runAgent(
    BuildContext context,
    GitController ctrl,
    String prompt,
  ) async {
    ctrl.requestAgentAction(prompt);
    await context.push('/chat');
  }

  void _workDirDialog(
    BuildContext context,
    GitController ctrl,
    GitState? current,
  ) {
    final controller =
        TextEditingController(text: current?.workDir ?? '');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Каталог репозитория'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Путь в песочнице',
            hintText: '/root/project',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              unawaited(ctrl.setWorkDir(controller.text.trim()));
            },
            child: const Text('Открыть'),
          ),
        ],
      ),
    );
  }

  void _cloneDialog(BuildContext context, GitController ctrl) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Клонировать репозиторий'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'URL',
            hintText: 'https://github.com/owner/repo.git',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              final url = controller.text.trim();
              Navigator.of(ctx).pop();
              if (url.isNotEmpty) {
                unawaited(_runAgent(context, ctrl, ctrl.clonePrompt(url)));
              }
            },
            child: const Text('Клонировать (агент)'),
          ),
        ],
      ),
    );
  }

  void _commitDialog(BuildContext context, GitController ctrl) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Коммит изменений'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Сообщение коммита',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              final msg = controller.text.trim();
              Navigator.of(ctx).pop();
              if (msg.isNotEmpty) {
                unawaited(_runAgent(context, ctrl, ctrl.commitPrompt(msg)));
              }
            },
            child: const Text('Коммит (агент)'),
          ),
        ],
      ),
    );
  }

  void _branchesSheet(
    BuildContext context,
    GitController ctrl,
    GitState? current,
  ) {
    final overview = current?.overview;
    final branches = overview?.branches ?? const <GitBranch>[];
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Ветки'),
            ),
            for (final b in branches)
              ListTile(
                leading: Icon(
                  b.current ? Icons.check_circle : Icons.radar,
                  size: 20,
                ),
                title: Text(b.name),
                trailing: b.current
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        tooltip: 'Переключиться (агент)',
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          unawaited(
                            _runAgent(
                              context,
                              ctrl,
                              ctrl.checkoutPrompt(b.name),
                            ),
                          );
                        },
                      ),
              ),
            if (branches.isEmpty)
              const ListTile(title: Text('Ветки не найдены')),
          ],
        ),
      ),
    );
  }
}

class _GitBody extends StatelessWidget {
  const _GitBody({required this.state, required this.ctrl});

  final GitState state;
  final GitController ctrl;

  @override
  Widget build(BuildContext context) {
    final o = state.overview;
    final diffs = state.diff;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (state.error != null) _MessageCard(text: state.error!, error: true),
        if (state.message != null) _MessageCard(text: state.message!),
        if (state.busy)
          const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          ),
        if (o != null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_tree_outlined, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          o.head.detached
                              ? 'detached @ ${o.head.oid.substring(0, 7)}'
                              : (o.head.branch.isEmpty
                                  ? '—'
                                  : o.head.branch),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (o.clean)
                        const Chip(
                          label: Text('чисто'),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.workDir,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 4),
                  Builder(
                    builder: (context) {
                      final oid = o.head.oid;
                      final max = oid.length.clamp(0, 12);
                      final short = oid.isEmpty
                          ? '—'
                          : oid.substring(0, max);
                      return Text(
                        'HEAD: $short',
                        style: const TextStyle(fontFamily: 'monospace'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Изменения (${o.vcsFiles.length})',
                  style: Theme.of(context).textTheme.titleSmall),
              if (diffs != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: ctrl.loadDiff,
                  child: const Text('обновить diff'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          if (o.vcsFiles.isEmpty)
            const ListTile(
              dense: true,
              leading: Icon(Icons.check),
              title: Text('Рабочее дерево чистое'),
            )
          else
            for (final f in o.vcsFiles)
              ListTile(
                dense: true,
                leading: Icon(
                  switch (f.status) {
                    'added' => Icons.add_circle_outline,
                    'deleted' => Icons.remove_circle_outline,
                    _ => Icons.edit_note,
                  },
                  size: 18,
                ),
                title: Text(
                  f.file,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
                subtitle: Text(
                  '+${f.additions} −${f.deletions}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          if (diffs != null && diffs.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final (file, patch) in diffs.take(3))
              ExpansionTile(
                title: Text(
                  file,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      patch.isEmpty ? '(нет patch от сервера)' : patch,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
          ],
          const SizedBox(height: 12),
          Text(
            'История (reflog)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          if (o.log.isEmpty)
            const ListTile(
              dense: true,
              leading: Icon(Icons.info_outline),
              title: Text('История недоступна'),
              subtitle: Text(
                'Новые коммиты появятся здесь после commit/merge '
                '(файл .git/logs/HEAD)',
              ),
            )
          else
            for (final c in o.log.take(20))
              ListTile(
                dense: true,
                leading: Text(
                  c.oid.length >= 7 ? c.oid.substring(0, 7) : c.oid,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
                title: Text(
                  c.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${c.author} · ${c.date}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
        ],
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.text, this.error = false});

  final String text;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: error
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SelectableText(
          text,
          style: error
              ? TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                )
              : null,
        ),
      ),
    );
  }
}
