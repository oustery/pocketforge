import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/core/platform/sandbox_channel.dart';

void main() {
  group('SandboxState', () {
    test('парсит полный map с нативной стороны', () {
      final s = SandboxState.fromMap(const <String, Object?>{
        'phase': 'ready',
        'message': 'Готово: 127.0.0.1:41235',
        'progress': null,
        'port': 41235,
        'healthy': true,
        'logTail': 'line1\nline2',
        'lastError': null,
      });
      expect(s.phase, SandboxPhase.ready);
      expect(s.port, 41235);
      expect(s.healthy, isTrue);
      expect(s.logTail, 'line1\nline2');
      expect(s.healthLabel, contains('OK'));
    });

    test('отсутствующие поля не ломают парсинг', () {
      final s = SandboxState.fromMap(const <String, Object?>{'phase': 'error'});
      expect(s.phase, SandboxPhase.error);
      expect(s.port, isNull);
      expect(s.healthy, isFalse);
      expect(s.message, isEmpty);
    });

    test('распознаёт имена этапов установки Android', () {
      const phases = {
        'installing_rootfs': SandboxPhase.installingRootfs,
        'downloading_opencode': SandboxPhase.downloadingOpencode,
        'bootstrapping_packages': SandboxPhase.bootstrappingPackages,
        'starting': SandboxPhase.starting,
      };
      for (final entry in phases.entries) {
        final state = SandboxState.fromMap({'phase': entry.key});
        expect(state.phase, entry.value);
        expect(state.preparing, isTrue);
        expect(state.isReady, isFalse);
      }
    });

    test('неизвестная фаза мапится в error', () {
      final s = SandboxState.fromMap(const <String, Object?>{
        'phase': 'future_phase',
      });
      expect(s.phase, SandboxPhase.error);
    });
  });
}
