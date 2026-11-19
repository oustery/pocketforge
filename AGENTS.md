# AGENTS.md — правила работы с репозиторием PocketForge

## Контекст проекта

Flutter-приложение Android (arm64-v8a only, minSdk 26, **targetSdk 28**),
внутри которого крутится песочница: proot + Alpine (aarch64) + opencode
serve (musl-arm64). Распространение через GitHub Releases, targetSdk 28 —
осознанное решение (обход FGS/scoped-storage ограничений новых API;
см. docs/этап 2, вопрос Q2 заказчика).

## Команды

```bash
flutter analyze          # линтер very_good_analysis — обязателен зелёный
flutter test             # unit-тесты
flutter test --tags integration   # интеграционные (нужен живой serve, см. ниже)
python3 scripts/gen_api_client.py api/openapi-1.19.6.json   # регенерация клиента
```

Интеграционные тесты: `LIVE_BASE_URL=http://127.0.0.1:PORT LIVE_PASSWORD=…`
против реального `opencode serve` (в CI — job с proot x86_64; локально —
эмулятор/песочница).

## Структура

- `lib/app/` — роутер, тема, bootstrap.
- `lib/core/api/` — сгенерированный клиент (`*.gen.dart` — НЕ редактировать
  руками, только через `scripts/gen_api_client.py`), SSE, интерсепторы.
- `lib/core/platform/` — MethodChannel к Kotlin-сервису песочницы.
- `lib/features/<name>/` — feature-first: UI + контроллеры фичи
  (runtime, auth, chat, git, files, terminal, settings, update).
- `android/app/src/main/kotlin/com/example/pocketforge/sandbox/` — нативный
  runtime: RuntimeService, ProotManager, RootfsInstaller, ArtifactsDownloader.
- `assets/` — artifacts.json (пин версий + sha256), rootfs tarball.
- `android/app/src/main/jniLibs/arm64-v8a/libproot.so` — proot 5.3.0 static.

## Правила

1. Версии пакетов — только через повышение pinned-строк в pubspec.yaml;
   обновлять ежеквартально отдельным PR.
2. Пин версии OpenCode менять одновременно в трёх местах: pubspec-логике
   тут нет — в `assets/artifacts.json` (url+sha256), README и, после регенерации,
   `api/openapi-*.json` (перегенерировать клиент).
3. `.gen.dart` файлы не править руками.
4. Kotlin: никаких сторонних зависимостей без необходимости — базовые
   HttpURLConnection/ProcessBuilder достаточны (M1–M2).
5. Пароль сервера и токены никогда не пишем в логи; Basic-заголовок
   санитизируется в лог-выводе.
6. targetSdk не поднимать без явного решения заказчика (28 — обход
   phantom-killer/FGS ограничений; adb-гайд остаётся).
7. Артефакты песочницы (rootfs, opencode) — только с проверкой sha256.
