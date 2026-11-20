import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/core/platform/sandbox_channel.dart';
import 'package:pocketforge/features/runtime/runtime_controller.dart';

/// Обзор рабочего пространства: состояние и следующий шаг.
class RuntimePage extends ConsumerWidget {
  /// Создаёт обзор.
  const RuntimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sandboxControllerProvider);
    final theme = Theme.of(context);
    final sandbox = state.asData?.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketForge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Настройки',
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ForgeFrame(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text('Рабочая среда', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(
                'OpenCode и Alpine Linux на вашем устройстве.',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              if (sandbox != null)
                _RuntimeCard(state: sandbox)
              else if (state.hasError)
                Card(
                  child: ForgeNotice(
                    icon: Icons.error_outline,
                    title: 'Не удалось прочитать состояние',
                    description: 'Повторите проверку песочницы.',
                    error: true,
                    action: OutlinedButton(
                      onPressed: () =>
                          ref.invalidate(sandboxControllerProvider),
                      child: const Text('Повторить'),
                    ),
                  ),
                )
              else
                const LinearProgressIndicator(
                  semanticsLabel: 'Проверяем песочницу',
                ),
              const ForgeSectionTitle('Управление'),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.key_outlined),
                      title: const Text('Провайдеры моделей'),
                      subtitle: const Text('Подключение к чату OpenCode'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/settings'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.monitor_heart_outlined),
                      title: const Text('Диагностика песочницы'),
                      subtitle: const Text('Подключение, журналы и сброс'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/diagnostics'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RuntimeCard extends ConsumerStatefulWidget {
  const _RuntimeCard({required this.state});

  final SandboxState state;

  @override
  ConsumerState<_RuntimeCard> createState() => _RuntimeCardState();
}

class _RuntimeCardState extends ConsumerState<_RuntimeCard> {
  bool _busy = false;

  Future<void> _command({required bool stop}) async {
    if (_busy) return;
    setState(() => _busy = true);
    final controller = ref.read(sandboxControllerProvider.notifier);
    try {
      if (stop) {
        await controller.stop();
      } else {
        await controller.start();
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Не удалось выполнить действие. Откройте диагностику.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final phase = state.phase;
    final theme = Theme.of(context);
    final active = state.preparing || phase == SandboxPhase.ready;
    final title = switch (phase) {
      SandboxPhase.uninitialized => 'Песочница не настроена',
      SandboxPhase.installingRootfs => 'Распаковываем Alpine Linux',
      SandboxPhase.downloadingOpencode => 'Загружаем OpenCode',
      SandboxPhase.bootstrappingApk => 'Устанавливаем пакеты',
      SandboxPhase.starting => 'Запускаем OpenCode',
      SandboxPhase.ready when state.isReady => 'Песочница готова',
      SandboxPhase.ready => 'Проверяем подключение',
      SandboxPhase.stopped => 'Песочница остановлена',
      SandboxPhase.error => 'Не удалось запустить песочницу',
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              child: ForgeBadge(
                switch (phase) {
                  SandboxPhase.error => Icons.error_outline,
                  SandboxPhase.ready when state.isReady => Icons.check_rounded,
                  _ => Icons.memory_outlined,
                },
                key: ValueKey((phase == SandboxPhase.error, state.isReady)),
                error: phase == SandboxPhase.error,
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              liveRegion: true,
              child: Text(title, style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            Text(switch (phase) {
              SandboxPhase.uninitialized =>
                'Для первого запуска нужен интернет. '
                    'Понадобится около 115 МБ трафика и 2 ГБ свободного места.',
              SandboxPhase.ready when state.isReady =>
                'Откройте чат или выберите '
                    'инструмент на нижней панели.',
              SandboxPhase.ready =>
                'Инструменты откроются, когда OpenCode ответит.',
              SandboxPhase.error =>
                'Повторите запуск. Если ошибка повторится, '
                    'подробности будут в диагностике.',
              SandboxPhase.stopped =>
                'Запустите среду снова, чтобы продолжить работу.',
              _ =>
                state.message.isEmpty
                    ? 'Подождите, пока среда подготовится.'
                    : state.message,
            }),
            if (state.preparing) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: state.progress?.clamp(0.0, 1.0).toDouble(),
                semanticsLabel: 'Подготовка песочницы',
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (state.isReady)
                  FilledButton.icon(
                    onPressed: () => context.go('/chat'),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Открыть чат'),
                  )
                else if (!active)
                  FilledButton.icon(
                    onPressed: _busy ? null : () => _command(stop: false),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      phase == SandboxPhase.error
                          ? 'Повторить запуск'
                          : 'Запустить песочницу',
                    ),
                  ),
                if (active)
                  OutlinedButton.icon(
                    onPressed: _busy ? null : () => _command(stop: true),
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text('Остановить'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
