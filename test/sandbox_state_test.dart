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

    test('неизвестная фаза мапится в error', () {
      final s = SandboxState.fromMap(
        const <String, Object?>{'phase': 'future_phase'},
      );
      expect(s.phase, SandboxPhase.error);
    });
  });
}
