import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/features/git/git_controller.dart';
import 'package:pocketforge/features/git/git_parsers.dart';
import 'package:pocketforge/features/git/git_service.dart';

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
        title: const Text('Git'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
            onPressed: state.value == null || state.value!.busy
                ? null
                : ctrl.refresh,
          ),
          PopupMenuButton<String>(
            tooltip: 'Действия с репозиторием',
            enabled: state.asData != null && state.value?.busy != true,
            onSelected: (value) {
              switch (value) {
                case 'clone':
                  _cloneDialog(context, ctrl);
                case 'commit':
                  _commitDialog(context, ctrl);
                case 'pull':
                  _openDraft(context, ctrl, ctrl.pullPrompt());
                case 'push':
                  _openDraft(context, ctrl, ctrl.pushPrompt());
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'clone',
                child: Text('Клонировать через чат…'),
              ),
              if (_hasRepository(state.value?.overview)) ...const [
                PopupMenuItem(
                  value: 'commit',
                  child: Text('Подготовить коммит…'),
                ),
                PopupMenuItem(value: 'pull', child: Text('Подготовить pull')),
                PopupMenuItem(value: 'push', child: Text('Подготовить push')),
              ],
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ForgeFrame(
          child: state.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Загружаем репозиторий',
              ),
            ),
            error: (_, _) => ForgeNotice(
              icon: Icons.error_outline,
              title: 'Репозиторий недоступен',
              description:
                  'Повторите загрузку или проверьте песочницу в обзоре.',
              error: true,
              action: OutlinedButton(
                onPressed: () => ref.invalidate(gitControllerProvider),
                child: const Text('Повторить'),
              ),
            ),
            data: (s) => RefreshIndicator(
              onRefresh: ctrl.refresh,
              child: _GitBody(
                state: s,
                ctrl: ctrl,
                onOpen: () => _workDirDialog(context, ctrl, s),
                onClone: () => _cloneDialog(context, ctrl),
                onBranches: () => _branchesSheet(context, ctrl, s),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openDraft(BuildContext context, GitController ctrl, String prompt) {
    ctrl.requestAgentAction(prompt);
    context.go('/chat');
  }

  void _workDirDialog(
    BuildContext context,
    GitController ctrl,
    GitState current,
  ) {
    unawaited(
      _askForText(
        context,
        title: 'Каталог репозитория',
        label: 'Путь в песочнице',
        initialValue: current.workDir,
        hint: '/root/workspace/проект',
        action: 'Открыть',
        onAccepted: (path) => unawaited(ctrl.setWorkDir(path)),
      ),
    );
  }

  void _cloneDialog(BuildContext context, GitController ctrl) {
    unawaited(
      _askForText(
        context,
        title: 'Клонировать репозиторий',
        label: 'URL',
        hint: 'https://github.com/owner/repo.git',
        action: 'Подготовить в чате',
        onAccepted: (url) => _openDraft(context, ctrl, ctrl.clonePrompt(url)),
      ),
    );
  }

  void _commitDialog(BuildContext context, GitController ctrl) {
    unawaited(
      _askForText(
        context,
        title: 'Коммит изменений',
        label: 'Сообщение коммита',
        action: 'Подготовить в чате',
        onAccepted: (message) =>
            _openDraft(context, ctrl, ctrl.commitPrompt(message)),
      ),
    );
  }

  Future<void> _askForText(
    BuildContext context, {
    required String title,
    required String label,
    required String action,
    required ValueChanged<String> onAccepted,
    String initialValue = '',
    String? hint,
  }) async {
    var value = initialValue;
    final form = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Form(
          key: form,
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(labelText: label, hintText: hint),
            validator: (input) =>
                (input ?? '').trim().isEmpty ? 'Заполните поле' : null,
            onSaved: (input) => value = input!.trim(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              if (!form.currentState!.validate()) return;
              form.currentState!.save();
              Navigator.of(dialogContext).pop(value);
            },
            child: Text(action),
          ),
        ],
      ),
    );
    if (result != null && context.mounted) onAccepted(result);
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
            const Padding(padding: EdgeInsets.all(16), child: Text('Ветки')),
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
                        tooltip: 'Подготовить переключение в чате',
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _openDraft(
                            context,
                            ctrl,
                            ctrl.checkoutPrompt(b.name),
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

bool _hasRepository(GitOverview? overview) =>
    overview != null &&
    (overview.head.branch.isNotEmpty || overview.head.oid.isNotEmpty);

class _GitBody extends StatelessWidget {
  const _GitBody({
    required this.state,
    required this.ctrl,
    required this.onOpen,
    required this.onClone,
    required this.onBranches,
  });

  final GitState state;
  final GitController ctrl;
  final VoidCallback onOpen;
  final VoidCallback onClone;
  final VoidCallback onBranches;

  @override
  Widget build(BuildContext context) {
    final o = state.overview;
    final diffs = state.diff;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: const Icon(Icons.folder_open_rounded),
            title: const Text('Каталог репозитория'),
            subtitle: Text(
              state.workDir,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            trailing: const Icon(Icons.edit_outlined),
            onTap: state.busy ? null : onOpen,
          ),
        ),
        const SizedBox(height: 12),
        if (state.error != null) _MessageCard(text: state.error!, error: true),
        if (state.message != null) _MessageCard(text: state.message!),
        if (state.busy)
          const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          ),
        if (!_hasRepository(o) && !state.busy)
          ForgeNotice(
            icon: Icons.account_tree_outlined,
            title: 'Репозиторий не открыт',
            description:
                'Укажите каталог существующего репозитория или подготовьте клонирование через чат.',
            action: FilledButton.tonal(
              onPressed: onClone,
              child: const Text('Клонировать через чат'),
            ),
          ),
        if (o != null && _hasRepository(o)) ...[
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
                              ? 'detached @ ${o.head.oid.substring(0, o.head.oid.length < 7 ? o.head.oid.length : 7)}'
                              : (o.head.branch.isEmpty ? '—' : o.head.branch),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: onBranches,
                      icon: const Icon(Icons.account_tree_outlined),
                      label: const Text('Ветки'),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final oid = o.head.oid;
                      final max = oid.length < 12 ? oid.length : 12;
                      final short = oid.isEmpty ? '—' : oid.substring(0, max);
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
          ForgeSectionTitle('Изменения (${o.vcsFiles.length})'),
          if (o.vcsFiles.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: ctrl.loadDiff,
                icon: const Icon(Icons.difference_outlined),
                label: Text(
                  diffs == null ? 'Показать различия' : 'Обновить различия',
                ),
              ),
            ),
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
                leading: Icon(switch (f.status) {
                  'added' => Icons.add_circle_outline,
                  'deleted' => Icons.remove_circle_outline,
                  _ => Icons.edit_note,
                }, size: 18),
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
            for (final (file, patch) in diffs)
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
          const ForgeSectionTitle('Последние операции Git'),
          const SizedBox(height: 4),
          if (o.log.isEmpty)
            const ListTile(
              dense: true,
              leading: Icon(Icons.info_outline),
              title: Text('История недоступна'),
              subtitle: Text(
                'Здесь появятся записи после изменений текущей ветки.',
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
              ? TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)
              : null,
        ),
      ),
    );
  }
}
