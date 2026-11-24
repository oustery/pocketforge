import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Абстракция хранения токенов приложения (для тестов — InMemory).
abstract class TokenStore {
  /// Сохраняет токен провайдера.
  Future<void> save(String provider, String token);

  /// Читает токен провайдера (или null).
  Future<String?> read(String provider);

  /// Удаляет токен провайдера.
  Future<void> delete(String provider);

  /// Список провайдеров с сохранёнными токенами.
  Future<List<String>> providers();
}

/// In-memory реализация для тестов и fallback при отсутствии плагина.
class InMemoryTokenStore implements TokenStore {
  final Map<String, String> _tokens = {};

  @override
  Future<void> save(String provider, String token) async {
    _tokens[provider] = token;
  }

  @override
  Future<String?> read(String provider) async => _tokens[provider];

  @override
  Future<void> delete(String provider) async {
    _tokens.remove(provider);
  }

  @override
  Future<List<String>> providers() async => _tokens.keys.toList();
}

/// Безопасное хранение через flutter_secure_storage (Keystore на Android).
/// При отсутствии плагина (юнит-тесты на хосте) прозрачно уходит в память.
class SecureTokenStore implements TokenStore {
  /// Создаёт стор.
  SecureTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final InMemoryTokenStore _fallback = InMemoryTokenStore();

  @override
  Future<void> save(String provider, String token) async {
    try {
      await _storage.write(key: _key(provider), value: token);
    } on Exception {
      // Молчаливый fallback маскировал потерю токена при рестарте
      // (in-memory хранилище не переживает перезапуск процесса).
      debugPrint(
        'TokenStore: secure storage недоступен, токен $provider '
        'сохранён в память и не переживёт рестарт',
      );
      await _fallback.save(provider, token);
    }
  }

  @override
  Future<String?> read(String provider) async {
    try {
      return await _storage.read(key: _key(provider));
    } on Exception {
      return await _fallback.read(provider);
    }
  }

  @override
  Future<void> delete(String provider) async {
    try {
      await _storage.delete(key: _key(provider));
    } on Exception {
      await _fallback.delete(provider);
    }
  }

  @override
  Future<List<String>> providers() async {
    try {
      final all = await _storage.readAll();
      return all.keys
          .where((k) => k.startsWith(_prefix))
          .map(_providerFromKey)
          .toList();
    } on Exception {
      return await _fallback.providers();
    }
  }

  static const String _prefix = 'opencode.auth.';

  String _key(String provider) => '$_prefix$provider';

  String _providerFromKey(String key) => key.substring(_prefix.length);
}
