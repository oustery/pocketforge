import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/features/chat/chat_controller.dart';
import 'package:pocketforge/features/chat/chat_page.dart';

/// Выбор активной сессии; первая создаётся только по действию пользователя.
class ChatRoute extends ConsumerStatefulWidget {
  /// Создаёт маршрут чата.
  const ChatRoute({super.key});

  @override
  ConsumerState<ChatRoute> createState() => _ChatRouteState();
}

class _ChatRouteState extends ConsumerState<ChatRoute> {
  bool _creating = false;

  Future<void> _newSession() async {
    if (_creating) return;
    setState(() => _creating = true);
    try {
      await ref.read(sessionsProvider.notifier).newSession();
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось создать чат. Попробуйте ещё раз.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionsProvider);
    final data = sessions.asData?.value;
    final active = data?.activeId;
    if (active != null) {
      return ChatPage(
        key: ValueKey(active),
        sessionID: active,
        onNewSession: _creating ? null : _newSession,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Чат')),
      body: SafeArea(
        child: sessions.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Загружаем чаты',
                ),
              )
            : sessions.hasError || data?.error != null
            ? ForgeNotice(
                icon: Icons.error_outline,
                title: 'Не удалось загрузить чаты',
                description:
                    'Проверьте подключение к песочнице и повторите попытку.',
                error: true,
                action: FilledButton.tonal(
                  onPressed: () => ref.invalidate(sessionsProvider),
                  child: const Text('Повторить'),
                ),
              )
            : ForgeNotice(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Начните разговор',
                description:
                    'Попросите OpenCode объяснить код или помочь с задачей. '
                    'Если модель ещё не подключена, сделайте это в настройках.',
                action: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: _creating ? null : _newSession,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(_creating ? 'Создаём чат…' : 'Новый чат'),
                    ),
                    TextButton(
                      onPressed: () => context.push('/settings'),
                      child: const Text('Подключить модель'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
