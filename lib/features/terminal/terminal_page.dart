import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
import 'package:pocketforge/features/runtime/runtime_controller.dart';
import 'package:pocketforge/features/terminal/terminal_controller.dart';

/// Команды внутри Alpine Linux и история вывода текущего терминала.
class TerminalPage extends ConsumerStatefulWidget {
  /// Создаёт страницу терминала.
  const TerminalPage({super.key});

  @override
  ConsumerState<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends ConsumerState<TerminalPage> {
  final TerminalSession _session = TerminalSession();
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _running = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    if (_running ||
        ref.read(sandboxControllerProvider).asData?.value.isReady != true) {
      return;
    }
    final cmd = _session.pushHistory(_input.text);
    _input.clear();
    if (cmd.isEmpty) {
      return;
    }
    setState(() => _running = true);
    _session.appendCommand(cmd);
    unawaited(_scrollToBottom());
    try {
      final channel = ref.read(sandboxChannelProvider);
      final outcome = await channel.exec(cmd, timeoutMs: 60000);
      _session.appendResult(outcome);
    } on PlatformException catch (e) {
      _session.appendError(e.message ?? e.code);
    } on Exception catch (e) {
      _session.appendError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _running = false);
        unawaited(_scrollToBottom());
      }
    }
  }

  Future<void> _scrollToBottom() async {
    if (!_scroll.hasClients) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!mounted || !_scroll.hasClients) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    } else {
      await _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  /// Подставляет команду из истории (вверх); у дна — самая старая.
  void _historyUp() {
    final cmd = _session.historyUp();
    if (cmd != null) {
      _input
        ..text = cmd
        ..selection = TextSelection.collapsed(offset: cmd.length);
    }
  }

  /// Подставляет команду из истории (вниз); ниже последней — пустой ввод.
  void _historyDown() {
    final cmd = _session.historyDown();
    if (cmd == null) {
      return;
    }
    _input
      ..text = cmd
      ..selection = TextSelection.collapsed(offset: cmd.length);
  }

  @override
  Widget build(BuildContext context) {
    final sandbox = ref.watch(sandboxControllerProvider);
    final ready = sandbox.asData?.value.isReady ?? false;
    final busy = ready && _running;
    final canInput = ready && !busy;
    final colors = Theme.of(context).colorScheme;
    final hasOutput = _session.output.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Терминал'),
        actions: [
          if (hasOutput)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Очистить вывод',
              onPressed: _running ? null : () => setState(_session.clear),
            ),
        ],
      ),
      body: SafeArea(
        child: ForgeFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (ready || hasOutput)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        ready ? Icons.terminal_rounded : Icons.link_off,
                        size: 20,
                        color: colors.primary,
                      ),
                      Text(
                        ready ? 'Alpine Linux · /root' : 'Песочница недоступна',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      if (!ready)
                        TextButton(
                          onPressed: () => context.go('/'),
                          child: const Text('К обзору'),
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: hasOutput
                    ? ColoredBox(
                        color: colors.surfaceContainerLow,
                        child: SingleChildScrollView(
                          controller: _scroll,
                          padding: const EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SelectableText(
                              _session.output,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                height: 1.45,
                              ),
                            ),
                          ),
                        ),
                      )
                    : sandbox.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          semanticsLabel: 'Проверяем терминал',
                        ),
                      )
                    : ForgeNotice(
                        icon: Icons.terminal_rounded,
                        title: ready ? 'Терминал готов' : 'Нужна песочница',
                        description: ready
                            ? 'Команды выполняются в Alpine Linux. '
                                  'Вывод и код завершения появятся здесь.'
                            : 'Запустите песочницу в обзоре.',
                        action: ready
                            ? OutlinedButton(
                                onPressed: () => _input.text = 'ls workspace',
                                child: const Text('Вставить ls workspace'),
                              )
                            : FilledButton.tonal(
                                onPressed: () => context.go('/'),
                                child: const Text('К обзору'),
                              ),
                      ),
              ),
              if (busy)
                const LinearProgressIndicator(
                  semanticsLabel: 'Выполняем команду',
                ),
              if (ready)
                Material(
                  color: colors.surfaceContainerLow,
                  child: Column(
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: canInput ? _historyUp : null,
                                  icon: const Icon(Icons.arrow_upward_rounded),
                                  tooltip: 'Предыдущая команда',
                                ),
                                IconButton(
                                  onPressed: canInput ? _historyDown : null,
                                  icon: const Icon(
                                    Icons.arrow_downward_rounded,
                                  ),
                                  tooltip: 'Следующая команда',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _input,
                                    enabled: canInput,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    textInputAction: TextInputAction.send,
                                    onSubmitted: (_) => unawaited(_run()),
                                    decoration: const InputDecoration(
                                      hintText: 'Команда',
                                      isDense: true,
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ListenableBuilder(
                                  listenable: _input,
                                  builder: (context, _) => IconButton.filled(
                                    onPressed:
                                        canInput &&
                                            _input.text.trim().isNotEmpty
                                        ? _run
                                        : null,
                                    icon: const Icon(Icons.play_arrow_rounded),
                                    tooltip: 'Выполнить команду',
                                  ),
                                ),
                              ],
                            ),
                          ],
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
