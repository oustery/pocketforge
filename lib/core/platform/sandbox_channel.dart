import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Фазы жизненного цикла песочницы (синхронизировано с Kotlin RuntimeService).
enum SandboxPhase {
  /// Песочница не инициализирована (после полного сброса).
  uninitialized,

  /// Скачивание и распаковка Debian rootfs (по манифесту артефактов).
  installingRootfs,

  /// Скачивание бинарника opencode (arm64).
  downloadingOpencode,

  /// Первый `apt-get install` внутри песочницы.
  bootstrappingPackages,

  /// Запуск proot + opencode serve, ожидание healthcheck.
  starting,

  /// Serve отвечает на healthcheck (200 c Basic-паролем).
  ready,

  /// Песочница остановлена (кнопкой или сервисом).
  stopped,

  /// Ошибка установки/запуска — см. [SandboxState.lastError].
  error,
}

/// Превращает имя фазы с нативной стороны в [SandboxPhase]; неизвестное
/// имя мапится в [SandboxPhase.error].
SandboxPhase sandboxPhaseFromName(String? name) =>
    SandboxPhase.values.firstWhere(
      (p) => p.name.toLowerCase() == name?.replaceAll('_', '').toLowerCase(),
      orElse: () => SandboxPhase.error,
    );

/// Снимок состояния песочницы, приходящий с нативной стороны.
@immutable
class SandboxState {
  /// Создаёт снимок состояния.
  const SandboxState({
    required this.phase,
    this.message = '',
    this.progress,
    this.port,
    this.healthy = false,
    this.logTail = '',
    this.lastError,
  });

  /// Разбирает map из MethodChannel (`status`/`onState`).
  factory SandboxState.fromMap(Object? map) {
    final m = Map<String, Object?>.from(map! as Map<Object?, Object?>);
    return SandboxState(
      phase: sandboxPhaseFromName(m['phase'] as String?),
      message: (m['message'] as String?) ?? '',
      progress: (m['progress'] as num?)?.toDouble(),
      port: m['port'] as int?,
      healthy: (m['healthy'] as bool?) ?? false,
      logTail: (m['logTail'] as String?) ?? '',
      lastError: m['lastError'] as String?,
    );
  }

  /// Текущая фаза жизненного цикла.
  final SandboxPhase phase;

  /// Человекочитаемое сообщение о текущем шаге/ошибке.
  final String message;

  /// Прогресс 0..1 для фаз установки/загрузки (иначе null).
  final double? progress;

  /// Порт serve на 127.0.0.1 (после успешного запуска).
  final int? port;

  /// Последний healthcheck прошёл (200 c Basic-паролем).
  final bool healthy;

  /// Хвост лога serve (до 8 КБ).
  final String logTail;

  /// Последняя ошибка установки/запуска.
  final String? lastError;

  /// Продолжается установка или запуск окружения.
  bool get preparing => switch (phase) {
    SandboxPhase.installingRootfs ||
    SandboxPhase.downloadingOpencode ||
    SandboxPhase.bootstrappingPackages ||
    SandboxPhase.starting => true,
    _ => false,
  };

  /// Инструменты могут работать с запущенной песочницей.
  bool get isReady => phase == SandboxPhase.ready && healthy;

  /// Метка healthcheck для UI.
  String get healthLabel => switch (phase) {
    SandboxPhase.ready when healthy => 'OK (200 с Basic-паролем)',
    SandboxPhase.ready => 'проверяется…',
    _ => '—',
  };
}

/// Результат команды в песочнице (M7 терминал).
@immutable
class ExecOutcome {
  /// Создаёт результат команды.
  const ExecOutcome({
    required this.code,
    required this.stdout,
    required this.stderr,
  });

  /// Разбирает map из MethodChannel (`exec`).
  factory ExecOutcome.fromMap(Object? map) {
    final m = Map<String, Object?>.from(map! as Map<Object?, Object?>);
    return ExecOutcome(
      code: (m['code'] as num?)?.toInt() ?? -1,
      stdout: (m['stdout'] as String?) ?? '',
      stderr: (m['stderr'] as String?) ?? '',
    );
  }

  /// Код возврата (0 — успех).
  final int code;

  /// stdout команды.
  final String stdout;

  /// stderr команды.
  final String stderr;
}

/// Типизированный мост Dart → Kotlin RuntimeService.
///
/// Канал двунаправленный: Dart вызывает методы (start/stop/status/reset),
/// нативная сторона пушит [SandboxState] через тот же канал.
class SandboxChannel {
  static const MethodChannel _channel = MethodChannel('pocketforge/sandbox');

  final StreamController<SandboxState> _states =
      StreamController<SandboxState>.broadcast();

  bool _handlerInstalled = false;

  /// Поток состояний, пушащихся с нативной стороны.
  Stream<SandboxState> get states => _states.stream;

  /// Регистрирует обработчик нативных пушей (вызывается один раз).
  void installHandler() {
    if (_handlerInstalled) {
      return;
    }
    _handlerInstalled = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onState') {
        _states.add(SandboxState.fromMap(call.arguments));
      }
      return null;
    });
  }

  /// Текущее состояние песочницы (запросом).
  Future<SandboxState> status() async {
    final res = await _channel.invokeMethod<Object?>('status');
    return SandboxState.fromMap(res);
  }

  /// Получает пароль только для текущего локального подключения.
  Future<String?> connectionPassword(int port) =>
      _channel.invokeMethod<String>('connectionPassword', {'port': port});

  /// Запуск песочницы через RuntimeService (startForegroundService).
  Future<void> start() => _channel.invokeMethod<void>('start');

  /// Остановка песочницы.
  Future<void> stop() => _channel.invokeMethod<void>('stop');

  /// Полный сброс содержимого песочницы.
  Future<void> reset() => _channel.invokeMethod<void>('reset');

  /// Экспорт логов песочницы: нативная сторона собирает zip (boot/apt/serve/
  /// proot-check + meta) и открывает системный share-шит. Возвращает путь.
  Future<String?> exportLogs() async {
    try {
      return await _channel.invokeMethod<String>('exportLogs');
    } on PlatformException {
      return null;
    }
  }

  /// Команда внутри песочницы (M7 терминал): `/bin/sh -c [command]` через
  /// proot. Блокирующий вызов на нативной стороне, таймаут [timeoutMs].
  ///
  /// Бросает [PlatformException] (`exec_failed`), если песочница не в фазе
  /// ready или команда не завершилась за отведённое время.
  Future<ExecOutcome> exec(String command, {int timeoutMs = 30000}) async {
    final res = await _channel.invokeMethod<Object?>('exec', {
      'command': command,
      'timeoutMs': timeoutMs,
    });
    return ExecOutcome.fromMap(res);
  }

  /// Снимает обработчик и закрывает поток состояний.
  void dispose() {
    unawaited(_states.close());
    _handlerInstalled = false;
    _channel.setMethodCallHandler(null);
  }
}
