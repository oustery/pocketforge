# PocketForge

Локальный OpenCode-агент для Android: приложение Flutter упаковывает
proot-песочницу (Alpine Linux aarch64 + opencode serve) и даёт мобильный
интерфейс — чат, файлы, терминал, git.

## Системные требования

| Требование | Значение |
|---|---|
| Архитектура | **только arm64-v8a** (32-битные устройства не поддерживаются) |
| Android | 8.0+ (minSdk 26), targetSdk 28 |
| RAM устройства | ≥ 4 ГБ |
| Диск | ≥ 2 ГБ свободно (rootfs + workspace + пакеты) |
| Сеть при первом запуске | Wi-Fi (~115 МБ: opencode + apk-пакеты) |
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

## Архитектура (кратко)

- **Песочница**: proot 5.3.0 (static, aarch64) как `libproot.so` + Alpine
  minirootfs 3.24.4 (asset) + opencode 1.19.6 (musl-arm64, скачивается,
  sha256 из `assets/artifacts.json`). Serve на `127.0.0.1:<random>`,
  Basic-пароль 128 бит на запуск.
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
- [ ] **M3** — авторизация (opencode OAuth через API, GitHub Device Flow)
- [ ] **M4** — чат MVP
- [ ] **M5** — git-интеграция
- [ ] **M6** — in-app update
- [ ] **M7** — обзор/терминал
- [ ] **M8** — полировка и бета

## Регенерация API-клиента

```bash
# запустить opencode serve (эмулятор/песочница) и снять спецификацию:
curl -s http://127.0.0.1:<port>/doc -o api/openapi-<ver>.json
python3 scripts/gen_api_client.py api/openapi-<ver>.json
fvm flutter analyze
```

## Лицензия

MIT — см. [LICENSE](LICENSE).
