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
    return DeviceCode(
      deviceCode: (data['device_code'] ?? '') as String,
      userCode: (data['user_code'] ?? '') as String,
      verificationUri:
          (data['verification_uri'] ?? 'https://github.com/login/device') as String,
      expiresInSeconds: (data['expires_in'] as num?)?.toInt() ?? 900,
      interval: (data['interval'] as num?)?.toInt() ?? 5,
    );
  }

  /// Опрашивает токен до успеха/истечения; соблюдает slow_down (+5 c).
  Future<DeviceFlowResult> poll(
    DeviceCode code, {
    void Function(int attempt, Duration nextDelay)? onWait,
  }) async {
    var interval = code.interval;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final res = await _dio.post<Map<String, Object?>>(
        config.tokenUrl,
        data: <String, Object?>{
          'client_id': config.clientId,
          'device_code': code.deviceCode,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );
      final data = res.data ?? const {};
      final error = data['error'] as String?;
      if (error == null || error.isEmpty) {
        return DeviceFlowResult(
          accessToken: (data['access_token'] ?? '') as String,
          tokenType: (data['token_type'] ?? 'bearer') as String,
          scope: (data['scope'] ?? '') as String,
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
    }
    throw DeviceFlowException('max_attempts', 'Опрос превысил лимит попыток');
  }
}
