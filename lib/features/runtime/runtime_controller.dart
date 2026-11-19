import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pocketforge/core/platform/sandbox_channel.dart';

/// Провайдер типизированного моста к нативному сервису песочницы.
final sandboxChannelProvider = Provider<SandboxChannel>((ref) {
  final channel = SandboxChannel()..installHandler();
  ref.onDispose(channel.dispose);
  return channel;
});

/// Контроллер песочницы: состояние с нативной стороны + команды.
class SandboxController extends AsyncNotifier<SandboxState> {
  StreamSubscription<SandboxState>? _sub;
  Timer? _poll;

  @override
  Future<SandboxState> build() async {
    final channel = ref.watch(sandboxChannelProvider);
    unawaited(_sub?.cancel());
    _sub = channel.states.listen((s) {
      state = AsyncValue<SandboxState>.data(s);
    });
    // Фолбэк-опрос статуса: нативные пуши могут быть пропущены,
    // пока страница не подписана (холодный старт).
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 3), (_) async {
      try {
        final s = await channel.status();
        final cur = state.value;
        if (cur == null ||
            cur.phase != s.phase ||
            cur.healthy != s.healthy ||
            cur.progress != s.progress ||
            cur.logTail != s.logTail) {
          state = AsyncValue<SandboxState>.data(s);
        }
      } on Exception {
        // Платформенный канал ещё не готов (сервис не поднят) — молча ждём.
      }
    });
    ref.onDispose(() {
      unawaited(_sub?.cancel());
      _poll?.cancel();
    });
    try {
      return await channel.status();
    } on PlatformException catch (e) {
      return SandboxState(
        phase: SandboxPhase.uninitialized,
        message: 'Сервис песочницы недоступен: ${e.message ?? e.code}',
      );
    }
  }

  /// Запуск песочницы (сервис сам выполнит установку и boot).
  Future<void> start() async {
    await ref.read(sandboxChannelProvider).start();
  }

  /// Остановка песочницы (proot завершается, сервис гасится).
  Future<void> stop() async {
    await ref.read(sandboxChannelProvider).stop();
  }

  /// Полный сброс: rootfs, workspace и скачанные артефакты удаляются.
  Future<void> reset() async {
    await ref.read(sandboxChannelProvider).reset();
  }
}

/// Провайдер контроллера песочницы для UI.
final sandboxControllerProvider =
    AsyncNotifierProvider<SandboxController, SandboxState>(
  SandboxController.new,
);
