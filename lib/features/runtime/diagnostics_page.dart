import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/features/runtime/runtime_controller.dart';

/// Технические сведения и обслуживание песочницы вне рабочего обзора.
class DiagnosticsPage extends ConsumerStatefulWidget {
  /// Создаёт экран диагностики.
  const DiagnosticsPage({super.key});

  @override
  ConsumerState<DiagnosticsPage> createState() => _DiagnosticsPageState();
}

class _DiagnosticsPageState extends ConsumerState<DiagnosticsPage> {
  bool _resetting = false;

  Future<void> _confirmReset() async {
    if (_resetting) return;
    setState(() => _resetting = true);
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Удалить данные песочницы?'),
          content: const Text(
            'Проекты, файлы и настройки внутри песочницы будут '
            'удалены. Для следующего запуска понадобится повторная загрузка.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
                foregroundColor: Theme.of(dialogContext).colorScheme.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Удалить данные'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      await ref.read(sandboxControllerProvider.notifier).reset();
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось сбросить песочницу.')),
        );
      }
    } finally {
      if (mounted) setState(() => _resetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sandbox = ref.watch(sandboxControllerProvider);
    final state = sandbox.asData?.value;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Диагностика')),
      body: SafeArea(
        child: ForgeFrame(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              const ForgeSectionTitle('Подключение'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    [
                      if (state != null) ...[
                        'Фаза: ${state.phase.name}',
                        'Проверка OpenCode: ${state.healthLabel}',
                        if (state.port case final port?)
                          'Адрес: 127.0.0.1:$port',
                        if (state.message.isNotEmpty) state.message,
                        if (state.lastError case final error?)
                          'Последняя ошибка: $error',
                      ] else if (sandbox.hasError)
                        'Не удалось прочитать состояние: ${sandbox.error}'
                      else
                        'Проверяем состояние…',
                    ].join('\n'),
                  ),
                ),
              ),
              const ForgeSectionTitle('Журналы'),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ExpansionTile(
                      leading: const Icon(Icons.receipt_long_outlined),
                      title: const Text('Журнал песочницы'),
                      subtitle: const Text('Последние записи запуска и работы'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SelectableText(
                              state?.logTail.isNotEmpty == true
                                  ? state!.logTail
                                  : 'Записей пока нет.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const _LogsExportRow(),
                  ],
                ),
              ),
              const ForgeSectionTitle('Сброс'),
              const Text('Удаляет всё содержимое песочницы, включая проекты.'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  onPressed: state == null || state.preparing || _resetting
                      ? null
                      : _confirmReset,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Сбросить песочницу'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Экспорт логов песочницы (boot.log, apk.log, serve.log + meta) в zip
/// через системный share-шит — для разбора ошибок запуска на устройстве.
class _LogsExportRow extends ConsumerStatefulWidget {
  /// Создаёт строку.
  const _LogsExportRow();

  @override
  ConsumerState<_LogsExportRow> createState() => __LogsExportRowState();
}

class __LogsExportRowState extends ConsumerState<_LogsExportRow> {
  bool _busy = false;
  String? _status;
  String? _error;

  Future<void> _export() async {
    setState(() {
      _busy = true;
      _status = null;
      _error = null;
    });
    try {
      final path = await ref.read(sandboxChannelProvider).exportLogs();
      if (!mounted) return;
      if (path == null) {
        setState(() {
          _busy = false;
          _status = 'Экспорт недоступен на этом устройстве';
        });
        return;
      }
      setState(() {
        _busy = false;
        _status =
            'Логи собраны, откроется окно отправки: ${path.split('/').last}';
      });
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.folder_zip_outlined),
      title: const Text('Экспорт логов'),
      subtitle: Text(
        _error != null
            ? 'Ошибка: $_error'
            : (_status ?? 'Поделиться архивом журналов через Android'),
      ),
      onTap: _busy ? null : _export,
    );
  }
}
