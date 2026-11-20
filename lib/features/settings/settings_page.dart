import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/features/runtime/runtime_controller.dart';
import 'package:pocketforge/features/update/update_service.dart';

/// Провайдер UpdateService.
final updateServiceProvider = Provider<UpdateService>((_) => UpdateService());

/// Настройки: провайдеры, обновления и справка.
class SettingsPage extends ConsumerWidget {
  /// Создаёт страницу настроек.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(
      sandboxControllerProvider.select(
        (value) => value.asData?.value.isReady ?? false,
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SafeArea(
        child: ForgeFrame(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              const ForgeSectionTitle('Провайдеры моделей'),
              if (!ready)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Запустите песочницу в обзоре, чтобы подключить модель.',
                  ),
                ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (final (index, (id, name)) in const [
                      ('anthropic', 'Anthropic'),
                      ('github-copilot', 'GitHub Copilot'),
                      ('openai', 'OpenAI'),
                    ].indexed) ...[
                      if (index > 0)
                        const Divider(height: 1, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.key_outlined),
                        title: Text(name),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        enabled: ready,
                        onTap: ready ? () => context.push('/auth/$id') : null,
                      ),
                    ],
                  ],
                ),
              ),
              const ForgeSectionTitle('Приложение'),
              const Card(
                child: Column(
                  children: [
                    UpdateSection(),
                    Divider(height: 1, indent: 16, endIndent: 16),
                    InstallPermissionRow(),
                  ],
                ),
              ),
              const ForgeSectionTitle('Справка'),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.auto_stories_outlined),
                      title: const Text('Знакомство с PocketForge'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/welcome?replay=1'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Лицензии'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: 'PocketForge',
                      ),
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

/// Секция обновлений: версия, проверка, скачивание, установка.
class UpdateSection extends ConsumerStatefulWidget {
  /// Создаёт секцию.
  const UpdateSection({super.key});

  @override
  ConsumerState<UpdateSection> createState() => _UpdateSectionState();
}

class _UpdateSectionState extends ConsumerState<UpdateSection> {
  String _version = '…';
  String? _status;
  String? _error;
  bool _checking = false;
  bool _downloading = false;
  int _received = 0;
  String? _downloadedPath;
  UpdateCheckResult? _pending;

  @override
  void initState() {
    super.initState();
    unawaited(_loadVersion());
  }

  Future<void> _loadVersion() async {
    final v = await ref.read(updateServiceProvider).currentVersion();
    if (mounted) setState(() => _version = v);
  }

  Future<void> _check() async {
    setState(() {
      _checking = true;
      _error = null;
      _status = null;
    });
    try {
      final svc = ref.read(updateServiceProvider);
      final cur = await svc.currentVersion();
      final res = await svc.checkForUpdate(currentVersion: cur);
      if (!mounted) return;
      setState(() {
        _checking = false;
        if (_pending?.version != res.version || !res.isUpdate) {
          _downloadedPath = null;
        }
        _pending = res.isUpdate ? res : null;
        _status = res.isUpdate
            ? 'Доступно обновление: ${res.version}'
            : 'У вас последняя версия ($cur)';
      });
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _checking = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _downloadAndInstall() async {
    final res = _pending;
    if (res == null || _downloading || _checking) return;
    setState(() {
      _downloading = true;
      _error = null;
    });
    try {
      final svc = ref.read(updateServiceProvider);
      var path = _downloadedPath;
      if (path == null || !File(path).existsSync()) {
        final dir = await getUpdatesDir();
        path = await svc.downloadApk(
          res.apkUrl,
          dir: dir,
          onProgress: (received, _) {
            if (mounted) setState(() => _received = received);
          },
        );
      }
      if (!mounted) return;
      setState(() => _downloadedPath = path);
      final status = await svc.installApk(path);
      if (status == InstallStatus.needsPermission && mounted) {
        setState(
          () =>
              _status = 'Разрешите установку в Android, затем вернитесь сюда.',
        );
        await svc.openInstallPermissionSettings();
      }
    } on Exception catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _downloading = false;
          _received = 0;
        });
      }
    }
  }

  /// Каталог для APK: кеш приложения (см. file_paths.xml).
  Future<Directory> getUpdatesDir() async {
    final base = Directory.systemTemp;
    return Directory('${base.path}${Platform.pathSeparator}updates');
  }

  @override
  Widget build(BuildContext context) {
    final canInstall = _pending != null;
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.system_update),
          title: const Text('Обновления'),
          subtitle: Text('Версия: $_version'),
          trailing: _checking
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Проверить обновления',
                  onPressed: _downloading ? null : _check,
                ),
        ),
        if (_status != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_status!, style: Theme.of(context).textTheme.bodySmall),
          ),
        if (_downloading && _downloadedPath == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Скачано ${(_received / (1024 * 1024)).toStringAsFixed(1)} МБ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (canInstall)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FilledButton.icon(
              onPressed: _downloading || _checking ? null : _downloadAndInstall,
              icon: Icon(
                _downloadedPath == null ? Icons.download : Icons.install_mobile,
              ),
              label: Text(
                _downloadedPath == null
                    ? 'Скачать и установить'
                    : 'Установить скачанное',
              ),
            ),
          ),
        if (_downloadedPath != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Установочный файл скачан',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Ошибка: $_error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}

/// Разрешение на установку APK и переход в настройки Android.
class InstallPermissionRow extends ConsumerStatefulWidget {
  /// Создаёт строку статуса.
  const InstallPermissionRow({super.key});

  @override
  ConsumerState<InstallPermissionRow> createState() =>
      _InstallPermissionRowState();
}

class _InstallPermissionRowState extends ConsumerState<InstallPermissionRow> {
  bool? _granted;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: () => unawaited(_refresh()));
    unawaited(_refresh());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final granted = await ref.read(updateServiceProvider).canRequestInstall();
    if (mounted) {
      setState(() => _granted = granted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final granted = _granted;
    return ListTile(
      leading: Icon(
        granted == null
            ? Icons.help_outline
            : granted
            ? Icons.check_circle_outline
            : Icons.error_outline,
      ),
      title: const Text('Право на установку APK'),
      subtitle: Text(
        granted == null
            ? 'Проверяется…'
            : granted
            ? 'Разрешено. Android попросит подтвердить установку.'
            : 'Нет — откройте системные настройки и разрешите установку',
      ),
      onTap: granted == false
          ? () async {
              await ref
                  .read(updateServiceProvider)
                  .openInstallPermissionSettings();
              await _refresh();
            }
          : null,
    );
  }
}
