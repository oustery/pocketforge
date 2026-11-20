import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketforge/app/design/forge_widgets.dart';
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
      if (!mounted) return;
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
      appBar: AppBar(title: const Text('Подключение модели')),
      body: SafeArea(
        child: ForgeFrame(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ForgeNotice(
              icon: Icons.error_outline,
              title: 'Не удалось загрузить способы входа',
              description:
                  'Проверьте готовность песочницы и повторите попытку.',
              error: true,
              action: OutlinedButton(
                onPressed: () => ctrl.loadMethods(widget.providerID),
                child: const Text('Повторить'),
              ),
            ),
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
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.tryParse(url);
    var opened = false;
    try {
      if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) {
        opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } on Exception {
      // Ссылка остаётся доступной для ручного копирования.
    }
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось открыть браузер. Скопируйте ссылку.'),
        ),
      );
    }
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
    final name = switch (providerID) {
      'github-copilot' => 'GitHub Copilot',
      'openai' => 'OpenAI',
      'anthropic' => 'Anthropic',
      _ => providerID,
    };
    if (state.phase == AuthUiPhase.done) {
      return ForgeNotice(
        icon: Icons.check_rounded,
        title: '$name подключён',
        description: 'Теперь этот провайдер доступен OpenCode в песочнице.',
        action: FilledButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Готово'),
        ),
      );
    }
    if (state.phase == AuthUiPhase.error && state.methods.isEmpty) {
      return ForgeNotice(
        icon: Icons.error_outline,
        title: 'Не удалось подключить $name',
        description: 'Повторите загрузку способов входа.',
        error: true,
        action: OutlinedButton(
          onPressed: () => ctrl.loadMethods(providerID),
          child: const Text('Повторить'),
        ),
      );
    }
    final waiting =
        state.phase == AuthUiPhase.waitingBrowser ||
        state.phase == AuthUiPhase.waitingCode;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: ForgeBadge(Icons.key_outlined),
        ),
        const SizedBox(height: 16),
        Text(name, style: Theme.of(context).textTheme.headlineMedium),
        if (state.phase == AuthUiPhase.finishing ||
            state.phase == AuthUiPhase.methodsLoading) ...[
          const SizedBox(height: 20),
          const LinearProgressIndicator(
            semanticsLabel: 'Подключаем провайдера',
          ),
        ] else if (waiting) ...[
          const ForgeSectionTitle('Подтверждение доступа'),
          _oauthCard(context),
          TextButton(
            onPressed: () => ctrl.loadMethods(providerID),
            child: const Text('Выбрать другой способ'),
          ),
        ] else ...[
          const ForgeSectionTitle('Способы входа'),
          if (state.error != null) ...[
            const Text(
              'Не удалось выполнить вход. Выберите способ и повторите попытку.',
            ),
            const SizedBox(height: 12),
          ],
          ..._methodCards(context),
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
          subtitle: Text(
            'OpenCode не предложил способов входа для этого провайдера.',
          ),
        ),
      ];
    }
    return [
      for (final m in state.methods)
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(
              m.type == 'oauth' ? Icons.open_in_new : Icons.vpn_key_outlined,
            ),
            title: Text(m.label.isEmpty ? m.type : m.label),
            subtitle: m.type == 'oauth'
                ? const Text('Через браузер, токен остаётся в песочнице')
                : const Text('Ручной ввод ключа'),
            onTap: () {
              if (m.type == 'oauth') {
                unawaited(_startOauth(m));
              } else {
                _showApiKeyDialog(context, m);
              }
            },
          ),
        ),
    ];
  }

  Future<void> _startOauth(AuthMethodChoice m) async {
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
            decoration: const InputDecoration(labelText: 'Ключ'),
            validator: (v) => (v == null || v.isEmpty) ? 'Введите ключ' : null,
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
                    labelText: 'Код подтверждения',
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
              const Text('После подтверждения в браузере вернитесь сюда.'),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ctrl.finishInBrowser(providerID),
                child: const Text('Завершить подключение'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
