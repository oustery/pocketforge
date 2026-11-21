# PocketForge

Локальный OpenCode-агент для Android: приложение Flutter упаковывает
proot-песочницу (Debian Linux aarch64 + opencode serve) и даёт мобильный
интерфейс — чат, файлы, терминал, git.

## Системные требования

| Требование | Значение |
|---|---|
| Архитектура | **только arm64-v8a** (32-битные устройства не поддерживаются) |
| Android | 8.0+ (minSdk 26), targetSdk 28 |
| RAM устройства | ≥ 4 ГБ |
| Диск | ≥ 2 ГБ свободно (rootfs + workspace + пакеты) |
| Сеть при первом запуске | Wi-Fi (~140 МБ: opencode + Debian rootfs + apt-пакеты) |
| Распространение | GitHub Releases + in-app update (Play не используется) |

## Сборка

```bash
fvm install            # Flutter 3.50.0 (см. .fvmrc)
fvm flutter pub get
fvm flutter analyze
fvm flutter test
fvm flutter build apk --release --target-platform android-arm64
```

Без fvm: `flutter --version` должна быть 3.50.0.

## Установка

Скачайте подписанный APK со страницы [Releases](https://github.com/oustery/pocketforge/releases/latest)
(`pocketforge-v*-arm64.apk`) и установите на устройство arm64 (Android 8.0+).

- Подпись: alias `pocketforge`, сертификат SHA256
  `64:AA:63:19:41:D8:38:DA:0A:3E:3A:83:A6:9B:16:BA:F7:E8:5A:15:65:E8:A8:B5:90:E6:B4:EC:54:AE:12:72`.
- Обновления — прямо в приложении: **Настройки → Проверить обновления**
  (appcast: `pocketforge-appcast.json` в этом репозитории).

## Архитектура (кратко)

- **Песочница**: proot 5.3.0 (static, aarch64) как `libproot.so` + Debian
  13 (trixie) slim rootfs (arm64v8, debuerreotype; OCI-слой tar.gz с URL,
  закреплённым коммитом) и opencode 1.19.6 (glibc-arm64; оба скачиваются
  при первом запуске, sha256 из `android/app/src/main/assets/artifacts.json`).
  Serve на `127.0.0.1:<random>`, Basic-пароль 128 бит на запуск. Пакеты
  (git, ripgrep, curl, ca-certificates, bash, libstdc++6) ставятся
  `apt-get` внутри proot при первом буте.
- **Runtime**: Kotlin-сервис `RuntimeService` (foreground service, wake lock,
  watchdog). Dart — через MethodChannel `pocketforge/sandbox`.
- **API-клиент**: генерируется из живой спецификации сервера `/doc`
  (`scripts/gen_api_client.py` → `lib/core/api/*.gen.dart`), SSE-стрим
  событий, Basic-интерсептор.

Полный план: `docs/` в корневом репозитории проекта (этапы 0–3).

## Вехи

- [x] **M0** — скелет проекта, CI, структура feature-first
- [x] **M1** — runtime-ядро: песочница (rootfs/opencode/apk/proot/health/watchdog)
- [x] **M2** — API-клиент OpenCode (188 операций, SSE, интеграционные тесты)
- [x] **M3** — авторизация (opencode OAuth через API, GitHub Device Flow)
- [x] **M4** — чат MVP
- [x] **M5** — git-интеграция
- [x] **M6** — in-app update (+ release-подпись из CI-секретов)
- [x] **M7** — обзор/терминал (exec в песочнице + appcast этого репо)
- [x] **M8** — полировка и бета (политики сети/разрешений, история терминала)

## Регенерация API-клиента

```bash
# запустить opencode serve (эмулятор/песочница) и снять спецификацию:
curl -s http://127.0.0.1:<port>/doc -o api/openapi-<ver>.json
python3 scripts/gen_api_client.py api/openapi-<ver>.json
fvm flutter analyze
```

## Лицензия

MIT — см. [LICENSE](LICENSE).
