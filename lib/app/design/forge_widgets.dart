import 'package:material_ui/material_ui.dart';

/// Ограничивает ширину панелей и текстовых экранов на больших устройствах.
class ForgeFrame extends StatelessWidget {
  /// Оборачивает содержимое экрана.
  const ForgeFrame({required this.child, super.key});

  /// Содержимое.
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: child,
    ),
  );
}

/// Иконка на тонированной подложке.
class ForgeBadge extends StatelessWidget {
  /// Создаёт компактный знак раздела или состояния.
  const ForgeBadge(this.icon, {this.error = false, super.key});

  /// Иконка.
  final IconData icon;

  /// Использовать цвет ошибки.
  final bool error;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: error ? colors.errorContainer : colors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: error ? colors.onErrorContainer : colors.onPrimaryContainer,
        ),
      ),
    );
  }
}

/// Единый формат пустого состояния с объяснением и следующим шагом.
class ForgeNotice extends StatelessWidget {
  /// Создаёт состояние экрана или отдельной панели.
  const ForgeNotice({
    required this.icon,
    required this.title,
    required this.description,
    this.action,
    this.error = false,
    super.key,
  });

  /// Иконка состояния.
  final IconData icon;

  /// Заголовок.
  final String title;

  /// Пояснение.
  final String description;

  /// Следующий шаг.
  final Widget? action;

  /// Использовать цвет ошибки.
  final bool error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ForgeBadge(icon, error: error),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
              if (action case final button?) ...[
                const SizedBox(height: 20),
                button,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Заголовок связанной группы элементов.
class ForgeSectionTitle extends StatelessWidget {
  /// Создаёт заголовок секции.
  const ForgeSectionTitle(this.title, {super.key});

  /// Название секции.
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 10),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
