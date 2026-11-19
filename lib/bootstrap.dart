import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/app/app.dart';

/// Точка входа приложения: инициализация биндингов и запуск.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: PocketForgeApp(),
    ),
  );
}
