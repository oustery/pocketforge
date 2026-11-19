# PocketForge — M7 (обзор/терминал) и закрытие релизного контура

Дата: 2026-11-19 · Репозиторий: [oustery/pocketforge](https://github.com/oustery/pocketforge) (ветка `main`, публичный)
Пайплайн: CI + Release на каждый пуш в `main` — Release публикует подписанный APK автоматически.

## 1. Что сделано

### M7. Обзор/терминал ✅

- **`exec` в песочнице (нативная часть)**: `ProotManager.exec(command, timeoutMs)` —
  та же конфигурация proot, что и у `runOnce` (rootfs, bind-маунты `/proc`, `/dev`,
  workspace→`/root/workspace`, `-0` fake-root, env-набор), но с раздельным захватом
  stdout/stderr и таймаутом с `destroyForcibly()`. `RuntimeService.execInSandbox()`
  в companion-объекте разрешает выполнение только в фазе `READY`; `MainActivity`
  выполняет вызов на отдельном executor'е и возвращает результат в UI-поток через
  `Handler(Looper.getMainLooper())` (MethodChannel.Result требует main-thread).
- **Dart-мост**: `SandboxChannel.exec()` + типизированный `ExecOutcome(code, stdout, stderr)`.
- **Терминал `/terminal`** (`lib/features/terminal/`): лента вывода в моноширинном
  шрифте (`$ команда` → stdout → stderr → `[exit N]`), поле ввода с кнопкой,
  прогресс при выполнении, «Очистить вывод». `TerminalSession` — чистая логика
  (формат, обрезка буфера хвостом при переполнении, история команд с листанием
  вверх/вниз и защитой от дублей подряд) — без UI и каналов, офлайн-тестируемая.
- **Обзор**: заголовок-карточка состояния песочницы (фаза из
  `sandboxControllerProvider`, health-индикатор, порт serve `127.0.0.1:<port>`).
- **Навигация**: роут `/terminal` в `app.dart`, кнопка `Icons.terminal` в AppBar
  главной страницы песочницы.

### Релизный контур — TODO(M6) закрыт ✅

- **Release-keystore** сгенерирован отдельно от debug-ключа (RSA 2048, alias
  `pocketforge`, срок 10 000 дней). Секреты `ANDROID_KEYSTORE_BASE64`,
  `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`
  залиты в репозиторий через API (sealed box). Сам keystore и пароли переданы
  владельцу вне репозитория (в git не попадают).
- **Подпись в CI**: `build.gradle.kts` читает путь/пароли из env; при наличии
  env release-APK подписывается release-ключом, без env (локальная сборка) —
  fallback на debug, как раньше. В `release.yml` добавлен шаг расшифровки
  секрета в `$RUNNER_TEMP` и контрольный шаг `apksigner verify --print-certs`.
- **Стабильное имя APK**: ассет релиза называется `pocketforge-v<версия>-arm64.apk`
  (без build-номера), поэтому прямая ссылка `releases/latest/download/…`
  не меняется от сборки к сборке. Тег релиза по-прежнему уникален:
  `v<версия>-build.<run_number>`.

### Appcast обновлений — с плейсхолдера на реальность ✅

- `kDefaultManifestUrl` указывал на чужую несуществующую организацию; теперь —
  `raw.githubusercontent.com/oustery/pocketforge/main/pocketforge-appcast.json`,
  файл закоммичен в корень репозитория (version/apkUrl/notes).
- Итог: «Настройки → Проверить обновления» из M6 работает на реальном манифесте,
  а «скачать последний APK» ведёт на последний релиз этого репозитория.

## 2. Версия и вехи

- `pubspec.yaml`: `0.2.0+2` (было `0.1.0+1`) — новый релиз получит тег
  `v0.2.0-build.<N>` и ассет `pocketforge-v0.2.0-arm64.apk`.
- README: раздел «Установка» (ссылка на Releases, SHA256 сертификата подписи),
  чекбоксы вех приведены к фактическому состоянию (M0–M7 ✅, M8 — полировка и бета).

## 3. Тесты и валидация

- `test/terminal_session_test.dart` — 11 тестов: формат вывода (эхо/stdout/stderr/
  `[exit N]`/ошибка канала), обрезка буфера с сохранением хвоста, история
  (pushHistory, historyUp/Down циклично, clear сохраняет историю).
- `flutter analyze` и `flutter test` прогнаны локально до пуша; CI повторяет
  обе проверки перед каждой сборкой релиза.

## 4. Ограничения и что дальше (M8)

- Терминал — **разовые команды** с таймаутом (60 с на команду в UI), не
  интерактивная PTY-сессия: нет stdin во время выполнения, нет автодополнения
  и escape-последовательностей. Для беты (M8) — при необходимости PTY через
  сокет-пару и потоковый вывод.
- `exec` доступен только при фазе `READY` — ошибка канала объясняет, что делать
  (запустить песочницу на главном экране).
- M8 (по плану README): полировка, рендер-проверка на эмуляторе, бета-выпуск;
  также упомянутые ранее «политики сети и разрешений».
