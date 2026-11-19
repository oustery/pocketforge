import 'dart:async';

import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/features/chat/chat_controller.dart';
import 'package:pocketforge/features/chat/chat_models.dart';

/// Чат MVP: стрим сообщений, Abort, Permission/Question-карточки, markdown.
class ChatPage extends ConsumerWidget {
  /// Создаёт страницу чата для [sessionID] (или активной).
  const ChatPage({required this.sessionID, super.key});

  /// Идентификатор сессии.
  final String sessionID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatControllerProvider(sessionID));
    final ctrl = ref.read(chatControllerProvider(sessionID).notifier);
    final sessions = ref.watch(sessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Чат', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: 'Новый чат',
            onPressed: () {
              unawaited(
                ref.read(sessionsProvider.notifier).newSession(),
              );
            },
          ),
        ],
      ),
      drawer: _SessionsDrawer(current: sessionID),
      body: Column(
        children: [
          Expanded(
            child: chat.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Ошибка: $e')),
              data: (state) => _MessageList(state: state, sessionID: sessionID),
            ),
          ),
          _Composer(sessionID: sessionID, ctrl: ctrl),
        ],
      ),
      bottomNavigationBar: sessions.value?.error != null
          ? SafeArea(
              child: Text(
                'Песочница не запущена: ${sessions.value!.error}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          : null,
    );
  }
}

class _SessionsDrawer extends ConsumerWidget {
  const _SessionsDrawer({required this.current});

  final String current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionsProvider);
    return Drawer(
      child: sessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (s) => ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Сессии')),
            for (final sess in s.sessions)
              ListTile(
                leading: Icon(
                  sess.id == current
                      ? Icons.chat_bubble
                      : Icons.chat_bubble_outline,
                ),
                title: Text(sess.title, maxLines: 1),
                subtitle: Text(sess.id, maxLines: 1),
                onTap: () {
                  ref.read(sessionsProvider.notifier).select(sess.id);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
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
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        for (final m in state.messages) _MessageBubble(message: m),
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
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

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
          children: [for (final p in visible) _PartView(part: p)],
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
            code: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
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
        border:
            Border.all(color: Theme.of(context).colorScheme.outlineVariant),
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
                  : Colors.green.shade600,
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
  const _PermissionCard({
    required this.permission,
    required this.sessionID,
  });

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
              Text(patterns.join(', '),
                  style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: id == null ? null : () => reply('once'),
                  child: const Text('Разрешить'),
                ),
                OutlinedButton(
                  onPressed: id == null ? null : () => reply('always'),
                  child: const Text('Всегда'),
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
  const _QuestionCard({
    required this.question,
    required this.sessionID,
  });

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
              for (final opt in (q['options'] as List?)
              ?.cast<Map<String, Object?>>()
              .whereType<Map<String, Object?>>()
              .toList() ?? const <Map<String, Object?>>[])
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.radio_button_unchecked, size: 18),
                  title: Text(
                    (opt['label'] ?? opt['value'] ?? '') as String,
                  ),
                  onTap: () {
                    if (id == null) return;
                    unawaited(
                      ref
                          .read(
                            chatControllerProvider(sessionID).notifier,
                          )
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _text,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Сообщение…',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) {
                  unawaited(_send());
                },
              ),
            ),
            const SizedBox(width: 8),
            if (streaming) IconButton.filled(
                    onPressed: () => widget.ctrl.interrupt(),
                    icon: const Icon(Icons.stop),
                    tooltip: 'Прервать (Abort)',
                  ) else IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: const Icon(Icons.send),
                    tooltip: 'Отправить',
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final text = _text.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await widget.ctrl.send(text);
      _text.clear();
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось отправить: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }
}
