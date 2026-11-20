import 'package:flutter/foundation.dart'
    show LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/app/app.dart';
import 'package:pocketforge/features/auth/auth_controller.dart';
import 'package:pocketforge/features/auth/token_store.dart';
import 'package:pocketforge/features/chat/chat_controller.dart';
import 'package:pocketforge/features/git/git_controller.dart';
import 'package:pocketforge/features/git/git_service.dart';
import 'package:pocketforge/features/runtime/workspace_connection.dart';

/// Точка входа приложения: связывает инструменты с локальным OpenCode.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Manrope-OFL.txt');
    yield LicenseEntryWithLineBreaks(['Manrope'], license);
  });
  final scope = ProviderScope(
    overrides: [
      chatClientProvider.overrideWith(
        (ref) => ref.watch(workspaceClientProvider).requireValue!,
      ),
      gitServiceProvider.overrideWith(
        (ref) => GitService(ref.watch(workspaceClientProvider).requireValue!),
      ),
      authClientProvider.overrideWith(
        (ref) => ref.watch(workspaceClientProvider).requireValue!,
      ),
      tokenStoreProvider.overrideWith((_) => SecureTokenStore()),
    ],
    child: const PocketForgeApp(),
  );
  runApp(scope);
}
