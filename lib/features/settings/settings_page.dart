import 'dart:async';

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:pocketforge/features/update/update_service.dart';

/// Провайдер UpdateService.
final updateServiceProvider = Provider<UpdateService>((_) => UpdateService());

/// Настройки: авторизация провайдеров (M3), песочница, обновления (M6).
class SettingsPage extends StatelessWidget {
  /// Создаёт страницу настроек.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.memory),
            title: Text('Песочница'),
            subtitle: Text('Управление — на главном экране (M1)'),
          ),
          const ListTile(
            leading: Icon(Icons.key_outlined),
            title: Text('Авторизация провайдеров'),
            subtitle: Text('OAuth через API opencode; токен — в песочнице'),
          ),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Войти — Anthropic'),
            onTap: () => context.push('/auth/anthropic'),
          ),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Войти — GitHub Copilot'),
            onTap: () => context.push('/auth/github-copilot'),
          ),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Войти — OpenAI'),
            onTap: () => context.push('/auth/openai'),
          ),
          const ListTile(
            leading: Icon(Icons.cloud_off),
            title: Text('Режим полёта'),
            subtitle: Text('Политики сети и разрешений — M8'),
          ),
          const Divider(height: 24),
          const UpdateSection(),
        ],
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
    if (res == null) return;
    setState(() {
      _downloading = true;
      _error = null;
    });
    try {
      final svc = ref.read(updateServiceProvider);
      final dir = await getUpdatesDir();
      final path = await svc.downloadApk(
        res.apkUrl,
        dir: dir,
        onProgress: (received, total) {
          if (mounted) setState(() => _received = received);
        },
      );
      if (!mounted) return;
      setState(() {
        _downloadedPath = path;
        _downloading = false;
        _received = 0;
      });
      final status = await svc.installApk(path);
      if (status == InstallStatus.needsPermission && mounted) {
        await svc.openInstallPermissionSettings();
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _error = e.toString();
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
                  onPressed: _check,
                ),
        ),
        if (_status != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _status!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (_downloading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Скачивание… $_received байт',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        if (canInstall)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FilledButton.icon(
              onPressed: _downloading ? null : _downloadAndInstall,
              icon: const Icon(Icons.download),
              label: const Text('Скачать и установить'),
            ),
          ),
        if (_downloadedPath != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'APK готов: $_downloadedPath',
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
