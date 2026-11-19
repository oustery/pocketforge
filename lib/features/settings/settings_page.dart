import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Настройки: авторизация провайдеров (M3), песочница, обновления.
class SettingsPage extends StatelessWidget {
  /// Создаёт страницу настроек.
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.memory),
            title: Text('Песочница'),
            subtitle: Text('Управление — на главном экране (M1)'),
          ),
          const ListTile(
            leading: Icon(Icons.key_outlined),
            title: Text('Авторизация провайдеров'),
            subtitle: Text('OAuth через API opencode; токен — в песочнице'),
          ),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Войти — Anthropic'),
            onTap: () => context.push('/auth/anthropic'),
          ),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Войти — GitHub Copilot'),
            onTap: () => context.push('/auth/github-copilot'),
          ),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Войти — OpenAI'),
            onTap: () => context.push('/auth/openai'),
          ),
          const ListTile(
            leading: Icon(Icons.cloud_off),
            title: Text('Режим полёта'),
            subtitle: Text('Политики сети и разрешений — M8'),
          ),
          const ListTile(
            leading: Icon(Icons.system_update),
            title: Text('Обновления'),
            subtitle: Text('In-app update — веха M6'),
          ),
        ],
      ),
    );
  }
}
