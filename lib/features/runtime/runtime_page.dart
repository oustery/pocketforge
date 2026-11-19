import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/core/platform/sandbox_channel.dart';
import 'package:pocketforge/features/runtime/runtime_controller.dart';

/// Статус песочницы и управление ею — рабочая верификация M1.
class RuntimePage extends ConsumerWidget {
  /// Создаёт страницу статуса песочницы.
  const RuntimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sandboxControllerProvider);
    final controller = ref.read(sandboxControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketForge — песочница'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Чат (M4)',
            onPressed: () => context.push('/chat'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Настройки',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (s) => _SandboxView(state: s, controller: controller),
      ),
    );
  }
}

class _SandboxView extends StatelessWidget {
  const _SandboxView({required this.state, required this.controller});

  final SandboxState state;
  final SandboxController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      state.phase.icon,
                      color: state.phase.color(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.phase.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                if (state.message.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(state.message),
                ],
                if (state.progress != null) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: state.progress),
                  const SizedBox(height: 4),
                  Text('${(state.progress! * 100).toStringAsFixed(0)} %'),
                ],
                if (state.port != null) ...[
                  const SizedBox(height: 8),
                  Text('127.0.0.1:${state.port} (пароль: внутри сервиса)'),
                ],
                const SizedBox(height: 8),
                Text(
                  'Healthcheck: ${state.healthLabel}',
                  style: TextStyle(
                    color: state.healthy
                        ? Colors.green.shade600
                        : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: controller.start,
              child: const Text('Запустить'),
            ),
            OutlinedButton(
              onPressed: controller.stop,
              child: const Text('Остановить'),
            ),
            OutlinedButton(
              onPressed: controller.reset,
              child: const Text('Сбросить песочницу'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Лог песочницы', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: const BoxConstraints(maxHeight: 260),
          child: SingleChildScrollView(
            reverse: true,
            child: Text(
              state.logTail.isEmpty ? '(пусто)' : state.logTail,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

extension _PhaseUi on SandboxPhase {
  String get label => switch (this) {
        SandboxPhase.uninitialized => 'Не инициализирована',
        SandboxPhase.installingRootfs => 'Распаковка rootfs',
        SandboxPhase.downloadingOpencode => 'Загрузка opencode',
        SandboxPhase.bootstrappingApk => 'Установка пакетов (apk)',
        SandboxPhase.starting => 'Запуск serve',
        SandboxPhase.ready => 'Готова',
        SandboxPhase.stopped => 'Остановлена',
        SandboxPhase.error => 'Ошибка',
      };

  IconData get icon => switch (this) {
        SandboxPhase.ready => Icons.check_circle_outline,
        SandboxPhase.error => Icons.error_outline,
        SandboxPhase.stopped => Icons.stop_circle_outlined,
        _ => Icons.sync,
      };

  Color color(BuildContext context) => switch (this) {
        SandboxPhase.ready => Colors.green.shade600,
        SandboxPhase.error => Theme.of(context).colorScheme.error,
        SandboxPhase.stopped => Colors.orange.shade700,
        _ => Theme.of(context).colorScheme.primary,
      };
}
