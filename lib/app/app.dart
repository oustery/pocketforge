import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/features/auth/auth_page.dart';
import 'package:pocketforge/features/chat/chat_route.dart';
import 'package:pocketforge/features/git/git_page.dart';
import 'package:pocketforge/features/runtime/runtime_page.dart';
import 'package:pocketforge/features/settings/settings_page.dart';

/// Провайдер роутера. M4: домашний экран — статус песочницы, чат —
/// активная сессия, авторизация — по провайдеру.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'runtime',
        builder: (context, state) => const RuntimePage(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatRoute(),
      ),
      GoRoute(
        path: '/git',
        name: 'git',
        builder: (context, state) => const GitPage(),
      ),
      GoRoute(
        path: '/auth/:provider',
        name: 'auth',
        builder: (context, state) =>
            AuthPage(providerID: state.pathParameters['provider']!),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});

/// Корневой виджет приложения (Material 3, светлая и тёмная темы).
class PocketForgeApp extends ConsumerWidget {
  /// Создаёт корневой виджет.
  const PocketForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'PocketForge',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      routerConfig: router,
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F6DF5),
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: 'Roboto',
    );
  }
}
