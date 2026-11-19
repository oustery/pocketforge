import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/core/platform/sandbox_channel.dart';
import 'package:pocketforge/features/terminal/terminal_controller.dart';

void main() {
  group('TerminalSession: формат вывода', () {
    test('эхо команды + stdout + маркер кода возврата', () {
      final s = TerminalSession()
        ..appendCommand('uname -m')
        ..appendResult(
          const ExecOutcome(code: 0, stdout: 'aarch64\n', stderr: ''),
        );
      expect(s.output, '\$ uname -m\naarch64\n[exit 0]\n');
    });

    test('stdout без завершающего перевода строки дополняется', () {
      final s = TerminalSession()
        ..appendResult(
          const ExecOutcome(code: 0, stdout: 'no-newline', stderr: ''),
        );
      expect(s.output, 'no-newline\n[exit 0]\n');
    });

    test('stderr печатается после stdout перед маркером', () {
      final s = TerminalSession()
        ..appendResult(
          const ExecOutcome(code: 2, stdout: 'out\n', stderr: 'err line\n'),
        );
      expect(s.output, 'out\nerr line\n[exit 2]\n');
    });

    test('ошибка канала добавляется строкой «ошибка: …»', () {
      final s = TerminalSession()..appendError('Песочница не готова');
      expect(s.output, 'ошибка: Песочница не готова\n');
    });
  });

  group('TerminalSession: обрезка буфера', () {
    test('хвост вывода сохраняется при переполнении', () {
      final s = TerminalSession(maxOutputChars: 32);
      for (var i = 0; i < 10; i++) {
        s.appendResult(ExecOutcome(code: 0, stdout: 'line-$i\n', stderr: ''));
      }
      final out = s.output;
      expect(out.length, lessThanOrEqualTo(200));
      expect(out, contains('line-9'));
      expect(out, isNot(contains('line-0\n')));
    });
  });

  group('TerminalSession: история команд', () {
    test('pushHistory: trim, без дублей подряд, сброс индекса', () {
      final s = TerminalSession();
      expect(s.pushHistory(' ls -la '), 'ls -la');
      s
        ..pushHistory('ls -la') // дубль подряд — не добавится
        ..pushHistory('uname -m');
      expect(s.history, ['ls -la', 'uname -m']);
      expect(s.historyIndex, isNull);
    });

    test('historyUp/Down циклично листает и возвращает к свободному вводу', () {
      final s = TerminalSession();
      expect(s.historyUp(), isNull); // пустая история
      s
        ..pushHistory('a')
        ..pushHistory('b')
        ..pushHistory('c');
      expect(s.historyUp(), 'c');
      expect(s.historyUp(), 'b');
      expect(s.historyUp(), 'a');
      expect(s.historyUp(), 'a'); // дальше дна — остаёмся
      expect(s.historyDown(), 'b');
      expect(s.historyDown(), 'c');
      expect(s.historyDown(), ''); // свободный ввод
      expect(s.historyDown(), isNull);
    });

    test('clear очищает вывод, но сохраняет историю', () {
      final s = TerminalSession()
        ..pushHistory('uname -m')
        ..appendCommand('uname -m')
        ..clear();
      expect(s.output, isEmpty);
      expect(s.history, ['uname -m']);
    });
  });
}
