import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Конфигурация in-app update.
///
/// `manifestUrl` — JSON-манифест: {"version":"1.2.3","apkUrl":"…",
/// "apkSha256":"…" (необязательно),"notes":"…"}. По умолчанию — appcast
/// этого репозитория (M7): файл обновляется вместе с релизами, APK-имя
/// стабильно (`pocketforge-v<версия>-arm64.apk`).
const String kDefaultManifestUrl =
    'https://raw.githubusercontent.com/oustery/pocketforge/main/'
    'pocketforge-appcast.json';

/// Результат проверки обновления.
@immutable
class UpdateCheckResult {
  /// Создаёт результат.
  const UpdateCheckResult({
    required this.version,
    required this.apkUrl,
    required this.notes,
    required this.isUpdate,
    this.apkSha256,
  });

  /// Версия из манифеста.
  final String version;

  /// URL APK.
  final String apkUrl;

  /// Заметки релиза.
  final String notes;

  /// Есть ли обновление относительно текущей версии.
  final bool isUpdate;

  /// Ожидаемый sha256 APK из манифеста (null — манифест не даёт якоря,
  /// целостность не проверяется).
  final String? apkSha256;
}

/// Статус установки APK (от платформенного канала).
/// Статус установки APK.
enum InstallStatus {
  /// Инсталлятор открыт.
  launched,

  /// Требуется право на установку — откройте настройки.
  needsPermission,
}

/// In-app update: проверка манифеста, скачивание APK, установка через
/// платформенный канал (FileProvider + REQUEST_INSTALL_PACKAGES).
class UpdateService {
  /// Создаёт сервис. [channel] — платформенный канал (для тестов).
  UpdateService({Dio? dio, MethodChannel? channel})
      : _dio = dio ?? Dio(),
        _channel = channel ??
            const MethodChannel('pocketforge/update');

  final Dio _dio;
  final MethodChannel _channel;

  /// Текущая версия приложения (с платформы).
  Future<String> currentVersion() async {
    try {
      final v = await _channel.invokeMethod<String>('version');
      return v ?? 'unknown';
    } on Exception {
      return 'unknown';
    }
  }

  /// Проверяет манифест и сравнивает версии.
  Future<UpdateCheckResult> checkForUpdate({
    required String currentVersion,
    String? manifestUrl,
  }) async {
    final url = manifestUrl ?? kDefaultManifestUrl;
    final res = await _dio.get<Map<String, Object?>>(
      url,
      options: Options(responseType: ResponseType.json),
    );
    final data = res.data ?? const <String, Object?>{};
    final version = (data['version'] ?? '') as String;
    final apkUrl = (data['apkUrl'] ?? '') as String;
    final notes = (data['notes'] ?? '') as String;
    final apkSha256 = (data['apkSha256'] ?? '') as String;
    if (version.isEmpty || apkUrl.isEmpty) {
      throw const FormatException('Манифест без version/apkUrl');
    }
    return UpdateCheckResult(
      version: version,
      apkUrl: apkUrl,
      notes: notes,
      isUpdate: semverCompare(version, currentVersion) > 0,
      apkSha256: apkSha256.isEmpty ? null : apkSha256.toLowerCase(),
    );
  }

  /// Скачивает APK в [dir] (по умолчанию кеш приложения).
  /// Возвращает путь к файлу.
  ///
  /// Если передан [expectedSha256] (из манифеста), файл проверяется по
  /// sha256: при расхождении выполняется одна повторная попытка, затем
  /// исключение. Битый/обрезанный APK — источник ошибки установщика
  /// «пакет недействителен (например, поврежден)», проверка ловит это
  /// до передачи файла в системный установщик.
  Future<String> downloadApk(
    String url, {
    required Directory dir,
    String? fileName,
    String? expectedSha256,
    void Function(int received, int? total)? onProgress,
  }) async {
    final name = fileName ?? url.split('/').last.split('?').first;
    final target = File('${dir.path}${Platform.pathSeparator}$name');
    await dir.create(recursive: true);
    for (var attempt = 1; attempt <= 2; attempt++) {
      final resp = await _dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );
      final bytes = resp.data;
      if (bytes == null || bytes.isEmpty) {
        throw Exception('Пустой ответ при скачивании APK');
      }
      onProgress?.call(bytes.length, bytes.length);
      await target.writeAsBytes(bytes, flush: true);
      final actual = sha256.convert(bytes).toString();
      if (expectedSha256 == null || actual == expectedSha256) {
        return target.path;
      }
      if (attempt == 2) {
        throw Exception(
          'APK скачан битым: sha256 $actual не совпал с ожидаемым '
          '$expectedSha256 даже после повторной попытки',
        );
      }
    }
    throw StateError('downloadApk: недостижимая ветка');
  }

  /// Устанавливает APK (Android: FileProvider + ACTION_VIEW).
  Future<InstallStatus?> installApk(String path) async {
    final r = await _channel.invokeMethod<String>(
      'installApk',
      {'path': path},
    );
    return switch (r) {
      'launched' => InstallStatus.launched,
      'needsPermission' => InstallStatus.needsPermission,
      _ => null,
    };
  }

  /// Открывает настройки установки приложений (Android 8+).
  Future<void> openInstallPermissionSettings() async {
    await _channel.invokeMethod<void>('openInstallPermissionSettings');
  }

  /// Право на установку APK (REQUEST_INSTALL_PACKAGES, M8).
  ///
  /// На платформах без канала (тесты) возвращает false.
  Future<bool> canRequestInstall() async {
    try {
      return await _channel.invokeMethod<bool>('canRequestInstall') ?? false;
    } on Exception {
      return false;
    }
  }
}

/// Сравнение семантических версий: -1 / 0 / 1.
///
/// Терпимо к префиксу 'v' и недостающим компонентам (1.2 == 1.2.0).
int semverCompare(String a, String b) {
  final pa = _parseSemver(a);
  final pb = _parseSemver(b);
  for (var i = 0; i < 3; i++) {
    if (pa[i] != pb[i]) return pa[i] < pb[i] ? -1 : 1;
  }
  return 0;
}

List<int> _parseSemver(String v) {
  var text = v.trim();
  if (text.startsWith('v')) text = text.substring(1);
  final core = text.split(RegExp(r'[+\-]')).first;
  final parts = core.split('.');
  return [
    for (var i = 0; i < 3; i++)
      int.tryParse(parts.length > i ? parts[i] : '0') ?? 0,
  ];
}
