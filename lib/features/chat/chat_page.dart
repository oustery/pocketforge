import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/features/chat/chat_controller.dart';
import 'package:pocketforge/features/chat/chat_models.dart';
import 'package:pocketforge/features/git/git_controller.dart';

/// Чат MVP: стрим сообщений, Abort, Permission/Question-карточки, markdown.
class ChatPage extends ConsumerWidget {
  /// Создаёт страницу чата для [sessionID] (или активной).
  const ChatPage({
    required this.sessionID,
    required this.onNewSession,
    super.key,
  });

  /// Создаёт сессию из списка чатов.
  final VoidCallback? onNewSession;

  /// Идентификатор сессии.
  final String sessionID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatControllerProvider(sessionID));
    final ctrl = ref.read(chatControllerProvider(sessionID).notifier);
    final active = ref
        .watch(sessionsProvider)
        .value
        ?.sessions
        .where((session) => session.id == sessionID)
        .firstOrNull;
    final title = active?.title.trim();
    return Scaffold(
      appBar: AppBar(
        title: Text(title == null || title.isEmpty ? 'Чат' : title),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Список чатов',
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              builder: (_) => _SessionsSheet(current: sessionID),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: 'Новый чат',
            onPressed: onNewSession,
          ),
        ],
      ),
      body: SafeArea(
        child: ForgeFrame(
          child: Column(
            children: [
              Expanded(
                child: chat.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => ForgeNotice(
                    icon: Icons.error_outline,
                    title: 'Не удалось открыть чат',
                    description: 'Повторите загрузку сообщений.',
                    error: true,
                    action: OutlinedButton(
                      onPressed: () =>
                          ref.invalidate(chatControllerProvider(sessionID)),
                      child: const Text('Повторить'),
                    ),
                  ),
                  data: (state) =>
                      _MessageList(state: state, sessionID: sessionID),
                ),
              ),
              if (chat.asData != null)
                _Composer(sessionID: sessionID, ctrl: ctrl),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionsSheet extends ConsumerWidget {
  const _SessionsSheet({required this.current});

  final String current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionsProvider).value?.sessions;
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const ForgeSectionTitle('Чаты'),
          if (sessions != null)
            for (final session in sessions)
              ListTile(
                selected: session.id == current,
                leading: const Icon(Icons.chat_bubble_outline_rounded),
                title: Text(
                  session.title.isEmpty ? 'Чат без названия' : session.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  ref.read(sessionsProvider.notifier).select(session.id);
                  Navigator.of(context).pop();
                },
              ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({required this.state, required this.sessionID});

  final ChatState state;
  final String sessionID;

  @override
  Widget build(BuildContext context) {
    if (state.messages.isEmpty &&
        state.error == null &&
        !state.streaming &&
        state.permissions.isEmpty &&
        state.questions.isEmpty) {
      return const ForgeNotice(
        icon: Icons.code_rounded,
        title: 'С какой задачи начнём?',
        description:
            'Опишите задачу и укажите файлы или каталог, с которыми нужно работать.',
      );
    }
    final items = <Widget>[
      for (final m in state.messages)
        _MessageBubble(key: ValueKey(m.id), message: m),
      if (state.error != null) _ErrorBanner(text: state.error!),
      if (state.streaming)
        const Padding(
          padding: EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        ),
      for (final p in state.permissions)
        _PermissionCard(permission: p, sessionID: sessionID),
      for (final q in state.questions)
        _QuestionCard(question: q, sessionID: sessionID),
    ];
    return ListView(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: items.reversed.toList(),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, super.key});

  final ChatMessageView message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final visible = message.parts
        .where((p) => p.kind != 'other' || p.text.isNotEmpty)
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUser ? 'Вы' : 'OpenCode',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            for (final p in visible) _PartView(part: p),
          ],
        ),
      ),
    );
  }
}

class _PartView extends StatelessWidget {
  const _PartView({required this.part});

  final ChatPartView part;

  @override
  Widget build(BuildContext context) {
    switch (part.kind) {
      case 'text':
        if (part.text.isEmpty) return const SizedBox.shrink();
        return MarkdownBody(
          data: part.text,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: Theme.of(context).textTheme.bodyMedium,
            code: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        );
      case 'reasoning':
        if (part.text.isEmpty) return const SizedBox.shrink();
        return _ReasoningTile(text: part.text);
      case 'tool':
        return _ToolCard(part: part);
      case 'file':
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Chip(
            avatar: const Icon(Icons.attach_file, size: 18),
            label: Text(part.fileName ?? part.url ?? 'файл'),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ReasoningTile extends StatefulWidget {
  const _ReasoningTile({required this.text});

  final String text;

  @override
  State<_ReasoningTile> createState() => _ReasoningTileState();
}

class _ReasoningTileState extends State<_ReasoningTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _open = !_open),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Размышления',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (_open)
              Container(
                margin: const EdgeInsets.only(top: 4, left: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                child: Text(
                  widget.text,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.part});

  final ChatPartView part;

  @override
  Widget build(BuildContext context) {
    final running =
        part.toolStatus == 'running' || part.toolStatus == 'pending';
    final failed = part.toolStatus == 'error';
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          if (running)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(
              failed ? Icons.error_outline : Icons.check_circle_outline,
              size: 16,
              color: failed
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              part.toolTitle?.isNotEmpty == true
                  ? '${part.toolName}: ${part.toolTitle}'
                  : (part.toolName ?? 'tool'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 18,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends ConsumerWidget {
  const _PermissionCard({required this.permission, required this.sessionID});

  final Map<String, Object?> permission;
  final String sessionID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = (permission['id'] ?? permission['permissionID']) as String?;
    final title =
        (permission['permission'] ?? permission['action'] ?? 'Действие')
            as String;
    final patterns =
        (permission['patterns'] as List?)?.cast<String>() ?? const [];
    void reply(String reply) {
      if (id == null) return;
      unawaited(
        ref
            .read(chatControllerProvider(sessionID).notifier)
            .replyPermission(id, reply),
      );
    }

    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shield_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Разрешение: $title',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            if (patterns.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                patterns.join(', '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: id == null ? null : () => reply('once'),
                  child: const Text('Разрешить один раз'),
                ),
                OutlinedButton(
                  onPressed: id == null ? null : () => reply('always'),
                  child: const Text('Разрешать всегда'),
                ),
                OutlinedButton(
                  onPressed: id == null ? null : () => reply('reject'),
                  child: const Text('Запретить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends ConsumerWidget {
  const _QuestionCard({required this.question, required this.sessionID});

  final Map<String, Object?> question;
  final String sessionID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = (question['id'] ?? question['requestID']) as String?;
    final questions =
        (question['questions'] as List?)
            ?.cast<Map<String, Object?>>()
            .toList() ??
        const <Map<String, Object?>>[];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final q in questions) ...[
              Text(
                (q['message'] ?? q['question'] ?? 'Вопрос') as String,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              for (final opt
                  in (q['options'] as List?)
                          ?.cast<Map<String, Object?>>()
                          .whereType<Map<String, Object?>>()
                          .toList() ??
                      const <Map<String, Object?>>[])
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.radio_button_unchecked, size: 18),
                  title: Text((opt['label'] ?? opt['value'] ?? '') as String),
                  onTap: () {
                    if (id == null) return;
                    unawaited(
                      ref
                          .read(chatControllerProvider(sessionID).notifier)
                          .replyQuestion(id, [
                            [(opt['label'] ?? opt['value'] ?? '') as String],
                          ]),
                    );
                  },
                ),
            ],
            TextButton(
              onPressed: id == null
                  ? null
                  : () => ref
                        .read(chatControllerProvider(sessionID).notifier)
                        .rejectQuestion(id),
              child: const Text('Отклонить'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends ConsumerStatefulWidget {
  const _Composer({required this.sessionID, required this.ctrl});

  final String sessionID;
  final ChatController ctrl;

  @override
  ConsumerState<_Composer> createState() => _ComposerState();
}

class _ComposerState extends ConsumerState<_Composer> {
  final TextEditingController _text = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatControllerProvider(widget.sessionID));
    final streaming = chat.value?.streaming ?? false;
    final draft = ref.watch(pendingGitActionProvider);
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          if (draft != null)
            ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text('Черновик из Git'),
              subtitle: const Text('Вставьте, проверьте и отправьте вручную.'),
              onTap: () {
                final existing = _text.text;
                final value = existing.trim().isEmpty
                    ? draft
                    : '$existing\n\n$draft';
                _text.value = TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(offset: value.length),
                );
                ref.read(pendingGitActionProvider.notifier).submit(null);
              },
              trailing: IconButton(
                tooltip: 'Удалить черновик Git',
                icon: const Icon(Icons.close_rounded),
                onPressed: () =>
                    ref.read(pendingGitActionProvider.notifier).submit(null),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _text,
                    enabled: !_sending,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Сообщение OpenCode',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (streaming)
                  IconButton.filledTonal(
                    onPressed: () => widget.ctrl.interrupt(),
                    icon: const Icon(Icons.stop_rounded),
                    tooltip: 'Прервать ответ',
                  )
                else
                  ListenableBuilder(
                    listenable: _text,
                    builder: (context, _) => IconButton.filled(
                      onPressed: _sending || _text.text.trim().isEmpty
                          ? null
                          : _send,
                      icon: const Icon(Icons.arrow_upward_rounded),
                      tooltip: 'Отправить',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _text.text.trim();
    if (_sending || text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await widget.ctrl.send(text);
      if (mounted) _text.clear();
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Не удалось отправить: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}
