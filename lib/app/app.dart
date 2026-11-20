import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketforge/app/design/forge_theme.dart';
import 'package:pocketforge/features/auth/auth_page.dart';
import 'package:pocketforge/features/chat/chat_route.dart';
import 'package:pocketforge/features/git/git_page.dart';
import 'package:pocketforge/features/onboarding/onboarding_page.dart';
import 'package:pocketforge/features/onboarding/onboarding_store.dart';
import 'package:pocketforge/features/runtime/diagnostics_page.dart';
import 'package:pocketforge/features/runtime/runtime_page.dart';
import 'package:pocketforge/features/runtime/workspace_connection.dart';
import 'package:pocketforge/features/settings/settings_page.dart';
import 'package:pocketforge/features/terminal/terminal_page.dart';

/// Роутер с отдельной историей каждой рабочей вкладки.
final routerProvider = Provider<GoRouter>((ref) {
  final store = ref.watch(onboardingStoreProvider);
  final router = GoRouter(
    initialLocation: '/launch',
    routes: [
      GoRoute(
        path: '/launch',
        redirect: (_, _) async {
          try {
            return await store.isComplete() ? '/' : '/welcome';
          } on Exception {
            return '/welcome';
          }
        },
      ),
      GoRoute(
        path: '/welcome',
        builder: (_, state) =>
            OnboardingPage(replay: state.uri.queryParameters['replay'] == '1'),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => _WorkspaceShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const RuntimePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (_, _) =>
                    const WorkspaceConnection(title: 'Чат', child: ChatRoute()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/git',
                builder: (_, _) =>
                    const WorkspaceConnection(title: 'Git', child: GitPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/terminal',
                builder: (_, _) => const TerminalPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),
      GoRoute(path: '/diagnostics', builder: (_, _) => const DiagnosticsPage()),
      GoRoute(
        path: '/auth/:provider',
        builder: (_, state) => WorkspaceConnection(
          title: 'Подключение модели',
          child: AuthPage(providerID: state.pathParameters['provider']!),
        ),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

class _WorkspaceShell extends StatelessWidget {
  const _WorkspaceShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    body: shell,
    bottomNavigationBar: MediaQuery.viewInsetsOf(context).bottom > 0
        ? null
        : NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: (index) {
              FocusManager.instance.primaryFocus?.unfocus();
              shell.goBranch(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.space_dashboard_outlined),
                selectedIcon: Icon(Icons.space_dashboard_rounded),
                label: 'Обзор',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline_rounded),
                selectedIcon: Icon(Icons.chat_bubble_rounded),
                label: 'Чат',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_tree_outlined),
                selectedIcon: Icon(Icons.account_tree_rounded),
                label: 'Git',
              ),
              NavigationDestination(
                icon: Icon(Icons.terminal_outlined),
                selectedIcon: Icon(Icons.terminal_rounded),
                label: 'Терминал',
              ),
            ],
          ),
  );
}

/// Корневой виджет приложения со светлой и тёмной темами.
class PocketForgeApp extends ConsumerWidget {
  /// Создаёт корневой виджет.
  const PocketForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'PocketForge',
    debugShowCheckedModeBanner: false,
    theme: forgeTheme(Brightness.light),
    darkTheme: forgeTheme(Brightness.dark),
    routerConfig: ref.watch(routerProvider),
  );
}
