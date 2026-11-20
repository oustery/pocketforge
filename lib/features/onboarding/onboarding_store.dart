import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Отметка знакомства, независимая от токенов и состояния песочницы.
class OnboardingStore {
  /// Создаёт хранилище.
  const OnboardingStore();

  Future<File> _marker() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}${Platform.pathSeparator}welcome-v1');
  }

  /// Проверяет, было ли знакомство завершено или пропущено.
  Future<bool> isComplete() async => (await _marker()).exists();

  /// Запоминает выбор пользователя на устройстве.
  Future<void> complete() async {
    final marker = await _marker();
    await marker.create(recursive: true);
  }
}

/// Хранилище первого запуска.
final onboardingStoreProvider = Provider<OnboardingStore>(
  (_) => const OnboardingStore(),
);
