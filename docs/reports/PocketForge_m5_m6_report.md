# PocketForge — реализация M5 (git-интеграция) и M6 (in-app update)

Дата: 2026-11-19 · Репозиторий: `/home/z/my-project/pocketforge/` (ветка `dev`, HEAD `df27697`)
Артефакты: [pocketforge-m0-m6.tar.gz](pocketforge-m0-m6.tar.gz) — полное дерево (M0–M6)

## 1. Что сделано

### M5. Git-интеграция ✅ (архитектура скорректирована по результатам верификации)

- **Чтение**: статус/дифф — нативные `GET /vcs/status`, `GET /vcs/diff` opencode
  (статус modified/added/deleted с +/-, патчи); ветки/история — парсинг `.git`
  через file API (HEAD, loose refs через `GET /file`, packed-refs, reflog
  `.git/logs/HEAD`). GitOverview: ветка + HEAD oid, изменённые файлы, diff-патчи,
  reflog-история, список веток.
- **Мутации** (clone/pull/push/checkout/commit): кнопки GitPage формируют промпт
  git-агенту и передают в чат-сессию (`pendingGitActionProvider` → ChatRoute
  автоотправка) — как и было задумано в плане («push/pull через открытый
  git-агент внутри session»).
- **GitPage** `/git`: карточка ветки (HEAD/oid/путь), изменения с +/-,
  раскрывающиеся diff-патчи, reflog-история, bottom-sheet веток с переключением,
  диалоги clone/commit, выбор каталога репозитория, pull-to-refresh.

### M6. In-app update ✅

- **UpdateService**: appcast-манифест (JSON: version/apkUrl/notes),
  `semverCompare` (v-префикс, недостающие компоненты), `checkForUpdate`,
  `downloadApk` с прогрессом в кеш, `installApk` через платформенный канал.
- **Android**: канал `pocketforge/update` (version / installApk /
  openInstallPermissionSettings) в MainActivity; FileProvider (`$id.fileprovider`,
  file_paths.xml: cache/files `updates/`); разрешение
  `REQUEST_INSTALL_PACKAGES`; androidx.core добавлен в gradle-зависимости.
- **Настройки**: секция «Обновления» — текущая версия, «Проверить обновления»,
  статус/прогресс скачивания, «Скачать и установить», обработка
  needsPermission (открытие настроек неизвестных источников).
- Манифест по умолчанию — плейсхолдер
  `https://raw.githubusercontent.com/pocketforge/pocketforge/main/pocketforge-appcast.json`
  (константа `kDefaultManifestUrl`), заменяется при публикации релизов.

## 2. Верификация

| Проверка | Результат |
|---|---|
| `flutter analyze` (very_good_analysis 11) | **No issues found** |
| `flutter test` (unit) | **48 passed** (+13 новых: git-парсеры 7, git-сервис 3, update 4) |
| Интеграционные на живом `opencode serve 1.19.6` | **8 passed**, включая новый **live git-тест**: реальный репозиторий в песочнице (`git init` + commit + правки) → ветка main, vcsStatus (modified/added), reflog с "initial commit" |

## 3. Ключевые находки и решения

1. **ptyCreate (node-pty) не работает в musl-песочнице**: bun-модуль node-pty —
   glibc-нативник, требует `ld-linux-x86-64.so.2`; gcompat падает на
   `gnu_get_libc_version`. Поэтому M5 построен **без pty** — это верно и для
   реального устройства (та же musl-корневая).
2. **`vcs/*` зависит от cwd serve**: с параметром `directory` opencode
   поднимает второй инстанс проекта и зависает в песочнице. Схема: serve
   запускается с cwd = корень репозитория (`/root/project`), GitService
   обращается к vsc-эндпоинтам без directory. Подтверждено live.
3. **file API**: пути к `.git` работают с абсолютным path
   (`/root/project/.git/HEAD`); `FileNode.absolute` — абсолютный, имя ветки
   вычисляется отсечением `$workDir/.git/`.
4. **История — reflog**: `.git/logs/HEAD` даёт коммиты, сделанные на устройстве
   (commit/merge/clone). Для клонированных репозиториев reflog содержит только
   запись clone — полная история появится в M7+ (читатель packfile-объектов)
   или через git-агента (промпт «покажи git log»).
5. **Обновление на устройстве**: APK скачивается в кеш приложения и
   устанавливается через FileProvider (Android 8+ требует
   REQUEST_INSTALL_PACKAGES — пользователь выдаёт право один раз; при его
   отсутствии открывается системная настройка).

## 4. Коммиты

- `242ada1` — M5: git-интеграция (vcs API + .git чтение + git-агент), 9 файлов, +1240
- `df27697` — M6: in-app update (манифест/скачивание/FileProvider), 7 файлов, +557
- `0d45831` — восстановление дерева M0–M4 из tarball (песочница пересоздавалась)

## 5. Как проверить

```bash
fvm flutter analyze && fvm flutter test
# live (serve из корня репо):
LIVE_BASE_URL=http://127.0.0.1:PORT LIVE_PASSWORD=... fvm flutter test --tags integration
```
