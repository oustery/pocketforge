import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/core/api/opencode_client.dart';
import 'package:pocketforge/features/runtime/runtime_controller.dart';

/// Клиент текущего запуска. Прогресс и логи не пересоздают соединение.
final workspaceClientProvider = FutureProvider<OpenCodeClient?>((ref) async {
  final port = ref.watch(
    sandboxControllerProvider.select((value) {
      final state = value.asData?.value;
      return state != null && state.isReady ? state.port : null;
    }),
  );
  if (port == null) return null;
  final password = await ref
      .watch(sandboxChannelProvider)
      .connectionPassword(port);
  if (!ref.mounted) return null;
  if (password == null || password.isEmpty) {
    throw StateError('Параметры подключения недоступны');
  }
  final client = OpenCodeClient(
    baseUrl: 'http://127.0.0.1:$port',
    password: password,
  );
  ref.onDispose(() => client.dio.close(force: true));
  return client;
});

/// Обёртка экранов, которым нужен работающий OpenCode.
class WorkspaceConnection extends ConsumerWidget {
  /// Показывает экран инструмента только при готовом подключении.
  const WorkspaceConnection({
    required this.title,
    required this.child,
    super.key,
  });

  /// Заголовок в состояниях ожидания и ошибки.
  final String title;

  /// Экран инструмента.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sandbox = ref.watch(
      sandboxControllerProvider.select(
        (value) => (
          loading: value.isLoading,
          ready: value.asData?.value.isReady ?? false,
          preparing: value.asData?.value.preparing ?? false,
        ),
      ),
    );
    final connection = ref.watch(workspaceClientProvider);
    final client = connection.asData?.value;
    if (sandbox.ready && !connection.isLoading && client != null) {
      return KeyedSubtree(key: ObjectKey(client), child: child);
    }
    final preparing = sandbox.preparing;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: switch ((
          sandbox.loading,
          connection.isLoading,
          connection.hasError,
        )) {
          (true, _, _) || (_, true, _) => const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Проверяем подключение',
            ),
          ),
          (_, _, true) => ForgeNotice(
            icon: Icons.link_off_rounded,
            title: 'Не удалось подключиться',
            description: 'Проверьте состояние песочницы или повторите попытку.',
            error: true,
            action: FilledButton.tonal(
              onPressed: () => ref.invalidate(workspaceClientProvider),
              child: const Text('Повторить'),
            ),
          ),
          _ => ForgeNotice(
            icon: Icons.memory_outlined,
            title: preparing ? 'Песочница готовится' : 'Нужна песочница',
            description: preparing
                ? 'Следите за прогрессом в обзоре. '
                      'После запуска инструмент станет доступен.'
                : 'Запустите песочницу в обзоре, чтобы открыть раздел.',
            action: FilledButton.tonal(
              onPressed: () => context.go('/'),
              child: const Text('К обзору'),
            ),
          ),
        },
      ),
    );
  }
}
