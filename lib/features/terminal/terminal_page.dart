import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:pocketforge/core/platform/sandbox_channel.dart';
import 'package:pocketforge/features/runtime/runtime_controller.dart';
import 'package:pocketforge/features/terminal/terminal_controller.dart';

/// M7 «обзор/терминал»: обзор состояния песочницы + команды внутри proot
/// (`/bin/sh -c …` в Alpine, stdout/stderr и код возврата в ленте вывода).
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
    if (_running) {
      return;
    }
    final cmd = _session.pushHistory(_input.text);
    _input.clear();
    if (cmd.isEmpty) {
      return;
    }
    setState(() => _running = true);
    _session.appendCommand(cmd);
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
      }
      unawaited(_scrollToBottom());
    }
  }

  Future<void> _scrollToBottom() async {
    if (!_scroll.hasClients) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (_scroll.hasClients) {
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
    final state = sandbox.value;
    final ready = state?.phase == SandboxPhase.ready && !_running;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Терминал песочницы (M7)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Очистить вывод',
            onPressed: () => setState(_session.clear),
          ),
        ],
      ),
      body: Column(
        children: [
          const _OverviewHeader(),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                _session.output.isEmpty
                    ? 'Команды выполняются в proot-песочнице (Alpine, /root). '
                        'Примеры: uname -m · apk list --installed · '
                        'ls workspace\n'
                    : _session.output,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
          ),
          if (_running) const LinearProgressIndicator(minHeight: 2),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      enabled: ready,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => unawaited(_run()),
                      decoration: const InputDecoration(
                        hintText: 'команда для /bin/sh, например uname -m',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: ready ? () => setState(_historyUp) : null,
                    icon: const Icon(Icons.arrow_upward),
                    tooltip: 'Из истории (вверх)',
                  ),
                  IconButton(
                    onPressed: ready ? () => setState(_historyDown) : null,
                    icon: const Icon(Icons.arrow_downward),
                    tooltip: 'Из истории (вниз)',
                  ),
                  IconButton.filled(
                    onPressed: ready ? () => unawaited(_run()) : null,
                    icon: _running
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    tooltip: 'Выполнить',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Обзор (M7): фаза/здоровье песочницы, порт serve и подсказка.
class _OverviewHeader extends ConsumerWidget {
  const _OverviewHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sandbox = ref.watch(sandboxControllerProvider);
    return sandbox.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(12),
        child: Text('Состояние песочницы: …'),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text('Состояние недоступно: $e'),
      ),
      data: (s) => Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              switch (s.phase) {
                SandboxPhase.ready when s.healthy => Icons.check_circle,
                SandboxPhase.error => Icons.error_outline,
                SandboxPhase.stopped => Icons.stop_circle_outlined,
                _ => Icons.hourglass_top,
              },
              size: 20,
              color: s.phase == SandboxPhase.ready && s.healthy
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                s.phase == SandboxPhase.ready
                    ? 'Песочница: ready · serve 127.0.0.1:${s.port ?? '—'}'
                    : 'Песочница: ${s.phase.name} · ${s.message}',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
