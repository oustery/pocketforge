import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/features/onboarding/onboarding_store.dart';

/// Знакомство с приложением до запуска и скачивания песочницы.
class OnboardingPage extends ConsumerStatefulWidget {
  /// Создаёт экран знакомства.
  const OnboardingPage({this.replay = false, super.key});

  /// Повторный просмотр из настроек.
  final bool replay;

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  bool _saving = false;
  bool _saveFailed = false;

  Future<void> _finish() async {
    if (_saving) return;
    if (widget.replay && context.canPop()) {
      context.pop();
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(onboardingStoreProvider).complete();
    } on Exception {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveFailed = true;
      });
      return;
    }
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ForgeFrame(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ForgeBadge(Icons.code_rounded),
                  TextButton(
                    onPressed: _saving ? null : _finish,
                    child: Text(widget.replay ? 'Закрыть' : 'Пропустить'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _WelcomeArtwork(),
              const SizedBox(height: 24),
              Text('PocketForge', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 8),
              const Text('Локальная среда разработки на Android'),
              const ForgeSectionTitle('С чего начать'),
              const Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.memory_outlined),
                      title: Text('Подготовить песочницу'),
                      subtitle: Text(
                        'Первый запуск скачает около 140 МБ. '
                        'Рекомендуем Wi-Fi и 2 ГБ свободного места.',
                      ),
                    ),
                    Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Icon(Icons.key_outlined),
                      title: Text('Подключить модель для чата'),
                      subtitle: Text(
                        'После запуска подключите провайдера '
                        'в настройках. Терминал не требует входа.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _saving ? null : _finish,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(
                  _saving
                      ? 'Сохраняем…'
                      : widget.replay
                      ? 'Готово'
                      : 'Открыть обзор',
                ),
              ),
              if (_saveFailed) ...[
                const SizedBox(height: 8),
                Text(
                  'Не удалось сохранить выбор.',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Продолжить без сохранения'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeArtwork extends StatelessWidget {
  const _WelcomeArtwork();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: ColoredBox(
          color: colors.primaryContainer,
          child: CustomPaint(
            painter: _GridPainter(
              colors.onPrimaryContainer.withValues(alpha: .13),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Icon(
                      Icons.terminal_rounded,
                      size: 40,
                      color: colors.primaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var x = size.width / 2 % 16; x < size.width; x += 16) {
      for (var y = size.height / 2 % 16; y < size.height; y += 16) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => oldDelegate.color != color;
}
