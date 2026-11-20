import 'package:pocketforge/core/platform/sandbox_channel.dart';

/// Логика терминала песочницы (M7): формат вывода, история команд,
/// обрезка буфера. Без UI и каналов — полностью тестируется офлайн.
class TerminalSession {
  /// Создаёт сессию. [maxOutputChars] — предел буфера вывода (обрезка сверху).
  TerminalSession({this.maxOutputChars = 100000});

  /// Максимальный размер вывода; при переполнении хвост сохраняется.
  final int maxOutputChars;

  final StringBuffer _output = StringBuffer();

  /// Полный вывод терминала (эхо команд, stdout/stderr, коды возврата).
  String get output => _output.toString();

  /// История команд, от старых к новым (дубликаты подряд не повторяются).
  final List<String> history = <String>[];

  /// Позиция листания истории; null — свободный ввод.
  int? historyIndex;

  /// Добавляет эхо команды в вывод.
  void appendCommand(String command) {
    _output.writeln('\$ $command');
    _trim();
  }

  /// Добавляет результат команды: stdout, stderr и маркер кода возврата.
  void appendResult(ExecOutcome outcome) {
    if (outcome.stdout.isNotEmpty) {
      _output.write(outcome.stdout);
      if (!outcome.stdout.endsWith('\n')) {
        _output.writeln();
      }
    }
    if (outcome.stderr.isNotEmpty) {
      _output.writeln(outcome.stderr.trimRight());
    }
    _output.writeln('[exit ${outcome.code}]');
    _trim();
  }

  /// Добавляет строку ошибки канала (песочница не готова, таймаут и т.п.).
  void appendError(String message) {
    _output.writeln('ошибка: $message');
    _trim();
  }

  /// Запоминает команду в истории (без дублей подряд) и возвращает её
  /// нормализованной (trim) — для эха и отправки.
  String pushHistory(String command) {
    final cmd = command.trim();
    if (cmd.isNotEmpty && (history.isEmpty || history.last != cmd)) {
      history.add(cmd);
    }
    historyIndex = null;
    return cmd;
  }

  /// Листает историю вверх; возвращает команду или null, если история пуста.
  String? historyUp() {
    if (history.isEmpty) {
      return null;
    }
    final i = (historyIndex ?? history.length) - 1;
    if (i < 0) {
      historyIndex = 0;
      return history.first;
    }
    historyIndex = i;
    return history[i];
  }

  /// Листает историю вниз; пустая строка — вернулись к свободному вводу,
  /// null — идти некуда (внизу истории или история пуста).
  String? historyDown() {
    if (history.isEmpty || historyIndex == null) {
      return null;
    }
    final i = historyIndex! + 1;
    if (i >= history.length) {
      historyIndex = null;
      return '';
    }
    historyIndex = i;
    return history[i];
  }

  /// Очищает вывод (история команд сохраняется).
  void clear() => _output.clear();

  void _trim() {
    if (_output.length > maxOutputChars) {
      final s = _output.toString();
      _output
        ..clear()
        ..write(s.substring(s.length - maxOutputChars));
    }
  }
}
