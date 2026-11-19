import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/features/chat/chat_controller.dart';
import 'package:pocketforge/features/chat/chat_page.dart';
import 'package:pocketforge/features/git/git_controller.dart';

/// Обёртка маршрута чата: выбирает активную сессию или создаёт первую.
class ChatRoute extends ConsumerStatefulWidget {
  /// Создаёт маршрут чата.
  const ChatRoute({super.key});

  @override
  ConsumerState<ChatRoute> createState() => _ChatRouteState();
}

class _ChatRouteState extends ConsumerState<ChatRoute> {
  bool _creating = false;

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionsProvider);
    return sessions.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 56),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Песочница недоступна: $e'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('На главный экран'),
              ),
            ],
          ),
        ),
      ),
      data: (s) {
        final active = s.activeId;
        if (active != null) {
          // Отложенное git-действие: отправить агенту и сбросить.
          final pending = ref.read(pendingGitActionProvider);
          if (pending != null) {
            ref.read(pendingGitActionProvider.notifier).submit(null);
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              try {
                await ref
                    .read(chatControllerProvider(active).notifier)
                    .send(pending);
              } on Exception catch (e) {
                ref.read(pendingGitActionProvider.notifier).submit(
                    'Не удалось отправить git-действие: $e',
                  );
              }
            });
          }
          return ChatPage(sessionID: active);
        }
        if (_creating) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Нет активной сессии — создаём первую.
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          setState(() => _creating = true);
          try {
            await ref.read(sessionsProvider.notifier).newSession();
          } on Exception {
            // ошибка уйдёт в состояние sessionsProvider
          } finally {
            if (mounted) setState(() => _creating = false);
          }
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
