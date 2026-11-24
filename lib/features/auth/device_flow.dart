import 'package:dio/dio.dart';

/// Фазы GitHub Device Flow (RFC 8628).
enum DeviceFlowPhase {
  /// Код показан, ждём подтверждения в браузере.
  waiting,

  /// Токен получен.
  approved,

  /// Код истёк.
  expired,

  /// Ошибка (сеть/клиент).
  error,
}

/// Конечные точки и параметры Device Flow (по умолчанию — GitHub).
class DeviceFlowConfig {
  /// Создаёт конфигурацию.
  const DeviceFlowConfig({
    required this.clientId, this.deviceCodeUrl = 'https://github.com/login/device/code',
    this.tokenUrl = 'https://github.com/login/oauth/access_token',
    this.scope = 'repo read:user',
  });

  /// Запрос кода устройства.
  final String deviceCodeUrl;

  /// Обмен кода на токен.
  final String tokenUrl;

  /// client_id OAuth-приложения (для opencode — из его GitHub OAuth App).
  final String clientId;

  /// Scope токена.
  final String scope;
}

/// Ответ на запрос кода устройства.
class DeviceCode {
  /// Создаёт результат запроса кода.
  const DeviceCode({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresInSeconds,
    required this.interval,
  });

  /// device_code для опроса.
  final String deviceCode;

  /// user_code — то, что вводит пользователь.
  final String userCode;

  /// URL для ввода кода.
  final String verificationUri;

  /// Время жизни кода, сек.
  final int expiresInSeconds;

  /// Интервал опроса, сек.
  final int interval;
}

/// Успешный результат обмена.
class DeviceFlowResult {
  /// Создаёт результат.
  const DeviceFlowResult({
    required this.accessToken,
    required this.tokenType,
    required this.scope,
  });

  /// access_token.
  final String accessToken;

  /// token_type (обычно bearer).
  final String tokenType;

  /// выданный scope.
  final String scope;
}

/// Ошибка Device Flow с кодом GitHub (expired_token и т.п.).
class DeviceFlowException implements Exception {
  /// Создаёт ошибку.
  DeviceFlowException(this.code, [this.message]);

  /// Машинный код ошибки.
  final String code;

  /// Человекочитаемое описание.
  final String? message;

  @override
  String toString() => 'DeviceFlowException($code): $message';
}

Future<void> _defaultSleep(Duration delay) => Future<void>.delayed(delay);

/// Клиент GitHub Device Flow: request code → poll token.
class GitHubDeviceFlow {
  /// Создаёт клиент поверх [Dio] (для тестов подставляется свой).
  /// [sleep] — инъекция паузы (в тестах — мгновенная).
  GitHubDeviceFlow({
    required this.config, Dio? dio,
    this.maxAttempts = 60,
    Future<void> Function(Duration delay)? sleep,
  })  : _dio = dio ?? Dio(),
        _sleep = sleep ?? _defaultSleep;



  /// Конфигурация эндпоинтов.
  final DeviceFlowConfig config;

  /// Верхняя граница числа опросов.
  final int maxAttempts;

  final Dio _dio;
  final Future<void> Function(Duration delay) _sleep;

  /// Запрашивает код устройства.
  Future<DeviceCode> requestCode() async {
    final res = await _dio.post<Map<String, Object?>>(
      config.deviceCodeUrl,
      data: <String, Object?>{
        'client_id': config.clientId,
        'scope': config.scope,
      },
      options: Options(headers: {'Accept': 'application/json'}),
    );
    final data = res.data ?? const {};
    final deviceCode = data['device_code'];
    final userCode = data['user_code'];
    if (deviceCode is! String ||
        deviceCode.isEmpty ||
        userCode is! String ||
        userCode.isEmpty) {
      // GitHub может вернуть 200 с телом {"error": …} — без валидации
      // опрос уходил в бесполезный цикл с пустым кодом.
      final descRaw = data['error_description'] ?? data['error'];
      throw DeviceFlowException(
        'invalid_request',
        descRaw is String
            ? descRaw
            : 'GitHub не вернул device_code/user_code',
      );
    }
    final uriRaw = data['verification_uri'];
    return DeviceCode(
      deviceCode: deviceCode,
      userCode: userCode,
      verificationUri: uriRaw is String
          ? uriRaw
          : 'https://github.com/login/device',
      expiresInSeconds: (data['expires_in'] as num?)?.toInt() ?? 900,
      interval: (data['interval'] as num?)?.toInt() ?? 5,
    );
  }

  /// Опрашивает токен до успеха/истечения; соблюдает slow_down (+5 c).
  ///
  /// Условие выхода — срок жизни кода ([DeviceCode.expiresInSeconds]),
  /// а не фиксированное число попыток: при интервале 5 с и коде на 15 мин
  /// 60 попыток заканчивались за ~5 минут, пока код ещё был жив.
  Future<DeviceFlowResult> poll(
    DeviceCode code, {
    void Function(int attempt, Duration nextDelay)? onWait,
  }) async {
    var interval = code.interval;
    final deadline =
        DateTime.now().add(Duration(seconds: code.expiresInSeconds));
    var attempt = 0;
    var networkFailures = 0;
    while (attempt < maxAttempts && DateTime.now().isBefore(deadline)) {
      Map<String, Object?> data;
      try {
        final res = await _dio.post<Map<String, Object?>>(
          config.tokenUrl,
          data: <String, Object?>{
            'client_id': config.clientId,
            'device_code': code.deviceCode,
            'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
          },
          options: Options(headers: {'Accept': 'application/json'}),
        );
        data = res.data ?? const {};
      } on DioException {
        // Мобильная сеть пропала на один опрос: код ещё жив минуты,
        // ронять весь flow из-за единичного сбоя — перезапрашивать код
        // не нужно. Лимит подряд — чтобы не крутиться на мёртвой сети.
        networkFailures++;
        if (networkFailures >= 5) {
          throw DeviceFlowException(
            'network',
            'Сеть недоступна при опросе токена (5 сбоев подряд)',
          );
        }
        final delay = Duration(seconds: interval);
        onWait?.call(attempt, delay);
        await _sleep(delay);
        continue;
      }
      networkFailures = 0;
      final errorRaw = data['error'];
      final error = errorRaw is String ? errorRaw : null;
      if (error == null || error.isEmpty) {
        final accessToken = data['access_token'];
        if (accessToken is! String || accessToken.isEmpty) {
          throw DeviceFlowException(
            'invalid_response',
            'GitHub не вернул access_token',
          );
        }
        final tokenTypeRaw = data['token_type'];
        final scopeRaw = data['scope'];
        return DeviceFlowResult(
          accessToken: accessToken,
          tokenType: tokenTypeRaw is String ? tokenTypeRaw : 'bearer',
          scope: scopeRaw is String ? scopeRaw : '',
        );
      }
      switch (error) {
        case 'authorization_pending':
          break;
        case 'slow_down':
          interval += 5;
        case 'expired_token':
          throw DeviceFlowException(error, 'Код устройства истёк');
        case 'unsupported_grant_type':
        case 'incorrect_client_credentials':
        case 'incorrect_device_code':
        case 'access_denied':
          throw DeviceFlowException(
            error,
            data['error_description'] as String?,
          );
        default:
          throw DeviceFlowException(
            error,
            data['error_description'] as String?,
          );
      }
      final delay = Duration(seconds: interval);
      onWait?.call(attempt, delay);
      await _sleep(delay);
      attempt++;
    }
    throw DeviceFlowException(
      DateTime.now().isBefore(deadline)
          ? 'max_attempts'
          : 'expired_token',
      DateTime.now().isBefore(deadline)
          ? 'Опрос превысил лимит попыток'
          : 'Код устройства истёк',
    );
  }
}
