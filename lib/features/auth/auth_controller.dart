import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketforge/core/api/opencode_client.dart';
import 'package:pocketforge/features/auth/token_store.dart';

/// Провайдер из ответа GET /provider/auth.
class AuthMethodChoice {
  /// Создаёт вариант метода.
  const AuthMethodChoice({
    required this.index,
    required this.type,
    required this.label,
    this.prompts = const [],
  });

  /// Парсит метод из map.
  factory AuthMethodChoice.fromMap(int index, Map<String, Object?> m) {
    final prompts = <AuthPrompt>[];
    final raw = m['prompts'];
    if (raw is List) {
      for (final p in raw) {
        if (p is Map) {
          prompts.add(
            AuthPrompt(
              key: (p['key'] ?? '') as String,
              message: (p['message'] ?? '') as String,
              placeholder: p['placeholder'] as String?,
            ),
          );
        }
      }
    }
    return AuthMethodChoice(
      index: index,
      type: (m['type'] ?? 'oauth') as String,
      label: (m['label'] ?? '') as String,
      prompts: prompts,
    );
  }

  /// Индекс метода (для authorize/callback).
  final int index;

  /// oauth или api.
  final String type;

  /// Человекочитаемое название.
  final String label;

  /// Дополнительные вопросы (для api-ключа и enterprise).
  final List<AuthPrompt> prompts;
}

/// Текстовый вопрос при авторизации (например, API-ключ).
class AuthPrompt {
  /// Создаёт вопрос.
  const AuthPrompt({
    required this.key,
    required this.message,
    this.placeholder,
  });

  /// Ключ поля.
  final String key;

  /// Сообщение пользователю.
  final String message;

  /// Placeholder.
  final String? placeholder;
}

/// Фазы авторизации в UI.
enum AuthUiPhase {
  /// Начальное состояние.
  idle,

  /// Загружаются методы провайдера.
  methodsLoading,

  /// Открыт браузер, ждём авто-callback.
  waitingBrowser,

  /// Ждём код от пользователя (method=code).
  waitingCode,

  /// Завершаем вход (callback/authSet).
  finishing,

  /// Вход выполнен.
  done,

  /// Ошибка.
  error,
}

/// Состояние экрана авторизации.
class AuthState {
  /// Создаёт состояние.
  const AuthState({
    required this.phase,
    this.methods = const [],
    this.authorizeUrl,
    this.instructions,
    this.methodIsCode = false,
    this.expiresHint,
    this.error,
    this.authenticatedProvider,
  });

  /// Текущая фаза.
  final AuthUiPhase phase;

  /// Методы текущего провайдера.
  final List<AuthMethodChoice> methods;

  /// URL для открытия в браузере (oauth authorize).
  final String? authorizeUrl;

  /// Инструкция сервера.
  final String? instructions;

  /// Сервер ждёт ввод кода (method=code).
  final bool methodIsCode;

  /// Подсказка об истечении (device flow).
  final String? expiresHint;

  /// Ошибка.
  final String? error;

  /// Провайдер, успешно авторизованный.
  final String? authenticatedProvider;
}

/// Провайдер клиента opencode для авторизации (переопределяется в тестах).
final authClientProvider = Provider<OpenCodeClient>(
  (_) => throw UnimplementedError(),
);

/// Провайдер хранилища токенов (переопределяется в тестах).
final tokenStoreProvider = Provider<TokenStore>(
  (_) => throw UnimplementedError(),
);

/// Контроллер авторизации: провайдер → методы → authorize → callback.
class AuthController extends AsyncNotifier<AuthState> {
  Timer? _poll;
  int _methodIndex = 0;

  @override
  Future<AuthState> build() async {
    ref.onDispose(() => _poll?.cancel());
    return const AuthState(phase: AuthUiPhase.idle);
  }

  /// Загружает методы авторизации провайдера.
  Future<void> loadMethods(String providerID) async {
    final client = ref.read(authClientProvider);
    state = const AsyncValue<AuthState>.loading();
    try {
      // GET /provider/auth возвращает свободную map: провайдер → методы.
      final res = await client.dio.get<Object?>('/provider/auth');
      final raw = res.data;
      // Ответ сервера может быть чем угодно: as Map на списке/строке
      // бросал TypeError (не Exception) мимо всех обработчиков.
      final data =
          raw is Map ? Map<String, Object?>.from(raw) : const <String, Object?>{};
      final entry = data[providerID];
      final methods = <AuthMethodChoice>[];
      if (entry is List) {
        for (var i = 0; i < entry.length; i++) {
          final m = entry[i];
          if (m is Map) {
            methods.add(
              AuthMethodChoice.fromMap(i, Map<String, Object?>.from(m)),
            );
          }
        }
      }
      state = AsyncValue<AuthState>.data(
        AuthState(phase: AuthUiPhase.idle, methods: methods),
      );
    } on Exception catch (e) {
      state = AsyncValue<AuthState>.data(
        AuthState(phase: AuthUiPhase.error, error: e.toString()),
      );
    }
  }

  /// Запускает OAuth через API: authorize → браузер (или ввод кода).
  Future<void> startOauth(
    String providerID, {
    required int methodIndex,
    Map<String, String>? inputs,
  }) async {
    final client = ref.read(authClientProvider);
    final methods = state.value?.methods ?? const <AuthMethodChoice>[];
    state = AsyncValue<AuthState>.data(
      AuthState(phase: AuthUiPhase.methodsLoading, methods: methods),
    );
    try {
      final auth = await client.providerOauthAuthorize(
        providerID: providerID,
        body: {'method': methodIndex, 'inputs': ?inputs},
      );
      _methodIndex = methodIndex;
      state = AsyncValue<AuthState>.data(
        AuthState(
          phase: auth.method == 'code'
              ? AuthUiPhase.waitingCode
              : AuthUiPhase.waitingBrowser,
          authorizeUrl: auth.url,
          instructions: auth.instructions,
          methodIsCode: auth.method == 'code',
          methods: state.value?.methods ?? const [],
        ),
      );
    } on Exception catch (e) {
      state = AsyncValue<AuthState>.data(
        AuthState(phase: AuthUiPhase.error, error: e.toString()),
      );
    }
  }

  /// Завершает OAuth: отправляет код из redirect/callback.
  Future<void> finishWithCode(String providerID, String code) async {
    final client = ref.read(authClientProvider);
    await _finish(
      providerID,
      () => client.providerOauthCallback(
        providerID: providerID,
        body: {'method': _methodIndex, 'code': code},
      ),
    );
  }

  /// Завершает Device Flow: экспортирует токен в песочницу (PUT /auth/{id}).
  Future<void> finishWithDeviceFlowToken(
    String providerID,
    String accessToken,
  ) async {
    final client = ref.read(authClientProvider);
    await _finish(
      providerID,
      () => client.authSet(
        providerID: providerID,
        body: {
          'type': 'oauth',
          // Device flow GitHub не выдаёт refresh-токен, и сам токен не
          // истекает по расписанию; поле обязательно для oauth-типа
          // opencode, поэтому горизонт 10 лет вместо ложных 30 дней,
          // после которых провайдер «молча» отваливался.
          'refresh': '',
          'access': accessToken,
          'expires':
              DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000 +
              3600 * 24 * 365 * 10,
          'accountId': 'device-flow',
        },
      ),
    );
  }

  /// Ручной ввод API-ключа (тип api, без OAuth).
  Future<void> finishWithApiKey(String providerID, String key) async {
    final client = ref.read(authClientProvider);
    await _finish(
      providerID,
      () => client.authSet(
        providerID: providerID,
        body: {'type': 'api', 'key': key},
      ),
    );
  }

  /// Отзывает авторизацию провайдера в песочнице.
  Future<void> revoke(String providerID) async {
    final client = ref.read(authClientProvider);
    try {
      await client.authRemove(providerID: providerID);
      await ref.read(tokenStoreProvider).delete(providerID);
      state = const AsyncValue<AuthState>.data(
        AuthState(phase: AuthUiPhase.done),
      );
    } on Exception catch (e) {
      state = AsyncValue<AuthState>.data(
        AuthState(phase: AuthUiPhase.error, error: e.toString()),
      );
    }
  }

  /// Завершает браузерный вход, при котором не требуется ввод кода.
  Future<void> finishInBrowser(String providerID) async {
    final client = ref.read(authClientProvider);
    await _finish(
      providerID,
      () => client.providerOauthCallback(
        providerID: providerID,
        body: {'method': _methodIndex},
      ),
    );
  }

  Future<void> _finish(
    String providerID,
    Future<bool> Function() action,
  ) async {
    try {
      state = AsyncValue<AuthState>.data(
        AuthState(
          phase: AuthUiPhase.finishing,
          methods: state.value?.methods ?? const [],
        ),
      );
      if (!await action()) {
        throw const FormatException('Провайдер не подтвердил вход');
      }
      state = AsyncValue<AuthState>.data(
        AuthState(phase: AuthUiPhase.done, authenticatedProvider: providerID),
      );
    } on Exception catch (e) {
      state = AsyncValue<AuthState>.data(
        AuthState(phase: AuthUiPhase.error, error: e.toString()),
      );
    }
  }
}

/// Провайдер контроллера авторизации.
final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
