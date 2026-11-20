import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/features/auth/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

/// Экран авторизации: выбор провайдера → методы → authorize/callback.
class AuthPage extends ConsumerStatefulWidget {
  /// Создаёт страницу авторизации.
  const AuthPage({required this.providerID, super.key});

  /// Провайдер, для которого логинимся (anthropic, github, ...).
  final String providerID;

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final TextEditingController _codeCtrl = TextEditingController();
  final TextEditingController _keyCtrl = TextEditingController();
  final GlobalKey<FormState> _codeForm = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref
            .read(authControllerProvider.notifier)
            .loadMethods(widget.providerID),
      );
    });
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final ctrl = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Вход — ${widget.providerID}')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (s) => _Body(
          state: s,
          providerID: widget.providerID,
          ctrl: ctrl,
          codeCtrl: _codeCtrl,
          keyCtrl: _keyCtrl,
          codeForm: _codeForm,
          keyForm: _keyForm,
          onLaunch: _launch,
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.state,
    required this.providerID,
    required this.ctrl,
    required this.codeCtrl,
    required this.keyCtrl,
    required this.codeForm,
    required this.keyForm,
    required this.onLaunch,
  });

  final AuthState state;
  final String providerID;
  final AuthController ctrl;
  final TextEditingController codeCtrl;
  final TextEditingController keyCtrl;
  final GlobalKey<FormState> codeForm;
  final GlobalKey<FormState> keyForm;
  final Future<void> Function(String) onLaunch;

  @override
  Widget build(BuildContext context) {
    if (state.phase == AuthUiPhase.done) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 72,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text('Авторизация $providerID выполнена'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Готово'),
            ),
          ],
        ),
      );
    }
    if (state.phase == AuthUiPhase.error && state.methods.isEmpty) {
      return Center(child: Text('Ошибка: ${state.error ?? '—'}'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (state.error != null) ...[
          Text(
            state.error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 8),
        ],
        ..._methodCards(context),
        if (state.phase == AuthUiPhase.waitingBrowser ||
            state.phase == AuthUiPhase.waitingCode ||
            state.phase == AuthUiPhase.finishing) ...[
          const SizedBox(height: 16),
          _oauthCard(context),
        ],
      ],
    );
  }

  List<Widget> _methodCards(BuildContext context) {
    if (state.methods.isEmpty) {
      return const [
        ListTile(
          leading: Icon(Icons.hourglass_empty),
          title: Text('Методы авторизации недоступны'),
          subtitle: Text('Запустите песочницу на главном экране'),
        ),
      ];
    }
    return [
      for (final m in state.methods)
        Card(
          child: ListTile(
            leading: Icon(m.type == 'oauth'
                ? Icons.open_in_new
                : Icons.vpn_key_outlined),
            title: Text(m.label.isEmpty ? m.type : m.label),
            subtitle: m.type == 'oauth'
                ? const Text('Через браузер, токен остаётся в песочнице')
                : const Text('Ручной ввод ключа'),
            onTap: () {
              if (m.type == 'oauth') {
                unawaited(_startOauth(context, m));
              } else {
                _showApiKeyDialog(context, m);
              }
            },
          ),
        ),
    ];
  }

  Future<void> _startOauth(
    BuildContext context,
    AuthMethodChoice m,
  ) async {
    final inputs = <String, String>{};
    for (final p in m.prompts) {
      // Вопросы сервера (если появятся) заполняются пусто;
      // сервер вернёт url и инструкции.
      inputs[p.key] = '';
    }
    await ctrl.startOauth(providerID, methodIndex: m.index, inputs: inputs);
  }

  void _showApiKeyDialog(BuildContext context, AuthMethodChoice m) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(m.label.isEmpty ? 'API-ключ' : m.label),
        content: Form(
          key: keyForm,
          child: TextFormField(
            controller: keyCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Ключ',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Введите ключ' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              if (keyForm.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop();
                unawaited(
                  ctrl.finishWithApiKey(providerID, keyCtrl.text.trim()),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  Widget _oauthCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.link),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.phase == AuthUiPhase.finishing
                        ? 'Завершаем вход…'
                        : 'Откройте ссылку и подтвердите доступ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (state.instructions != null) ...[
              const SizedBox(height: 8),
              Text(state.instructions!),
            ],
            if (state.authorizeUrl != null) ...[
              const SizedBox(height: 8),
              SelectableText(
                state.authorizeUrl!,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => unawaited(onLaunch(state.authorizeUrl!)),
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Открыть браузер'),
              ),
            ],
            if (state.methodIsCode) ...[
              const SizedBox(height: 12),
              Form(
                key: codeForm,
                child: TextFormField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Код из redirect/callback',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Введите код' : null,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  if (codeForm.currentState?.validate() ?? false) {
                    unawaited(
                      ctrl.finishWithCode(providerID, codeCtrl.text.trim()),
                    );
                  }
                },
                child: const Text('Подтвердить'),
              ),
            ],
            if (state.phase == AuthUiPhase.waitingBrowser) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              const Text(
                'После подтверждения сервер автоматически получит токен; '
                'если он покажет код — вставьте его в поле ниже.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
