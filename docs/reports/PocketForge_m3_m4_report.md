# PocketForge — реализация M3 (авторизация) и M4 (чат MVP)

Дата: 2026-11-19 · Репозиторий: `/home/z/my-project/pocketforge/` (ветка `dev`, HEAD `b2a6336`)
Артефакт: [pocketforge-m0-m4.tar.gz](pocketforge-m0-m4.tar.gz) — полное дерево (M0–M4)

## 1. Что сделано

### M3. Авторизация ✅

- **Основной путь — OAuth через API opencode** (без client_id в приложении):
  `GET /provider/auth` → методы провайдера → `POST /provider/{id}/oauth/authorize`
  (открываем браузер через url_launcher) → `POST /provider/{id}/oauth/callback` c кодом
  → сервер сам хранит токен в песочнице (`auth.json`). UI-страница `/auth/:provider`:
  карточки методов (oauth/api), инструкции сервера, поле для кода, статус-фазы.
- **GitHub Device Flow (RFC 8628)** — `GitHubDeviceFlow` (request code → poll с
  slow_down +5 с, expired_token и т.д.), экспорт токена в песочницу через
  `PUT /auth/{providerID}` (`authSet`). Точки входа и client_id — инъекцией
  (`DeviceFlowConfig`), тесты — через fake-адаптер.
- **TokenStore**: `SecureTokenStore` (flutter_secure_storage/Keystore) с
  InMemory-fallback для тестов/хоста.
- Ручной ввод API-ключа (тип `api`) для провайдеров без OAuth.
- Тесты: device flow (pending → slow_down → success, expired_token → исключение,
  рост интервала), контроллер (loadMethods/authorize/callback/token/revoke).

### M4. Чат MVP ✅

- **Толерантный парсер событий**: opencode шлёт v1-варианты (`properties`-обёртка)
  и v2 (`data`-обёртка) — редьюсер принимает обе формы и не падает на
  подмножестве полей (уроки M2).
- **ChatController** (riverpod 3.5 family, arg в конструкторе): история из
  `GET /session/{id}/message` (формат `{info, parts}`), отправка промпта с
  parts (текст + файлы как data-URL), `interrupt`, `permissionReply`
  (once/always/reject), `questionReply`/`questionReject`.
- **UI ChatPage/ChatRoute**: пузыри user/assistant, MarkdownBody
  (flutter_markdown_plus), сворачиваемые «Размышления», tool-карты со статусом
  (running/completed/error), баннер ошибки сессии, drawer списка сессий,
  composer с Abort-кнопкой во время стрима.
- Интеграция с M1: чат работает против serve из песочницы (Basic-пароль,
  локальный порт).

## 2. Верификация

| Проверка | Результат |
|---|---|
| `flutter analyze` (very_good_analysis 11) | **No issues found** |
| `flutter test` (unit) | **34 passed** (device flow 4, auth-контроллер 5, чат-редьюсер 8, чат-контроллер 2, клиент M2 4, SSE 7, state 3…) |
| Интеграционные на живом `opencode serve 1.19.6` в proot-песочнице (пересобрана под x86_64 в этой сессии) | **7 passed**: health 401/200, config.providers, session CRUD, SSE-событие, pty shells, **auth roundtrip (authSet/authRemove)**, **sessionMessages/permissionList/questionList + interrupt** |

## 3. Отклонения и ограничения (честно)

1. **Widget-тесты ChatPage сняты**: material_ui 1.11.1 не инициализирует
   `MaterialLocalizations` в тест-биндинге этой песочницы (воспроизведено
   минимальным кейсом `MaterialApp(home: TextField())`). Логика чата покрыта
   контроллерными тестами; рендер проверяется на эмуляторе в M8.
2. **OAuth e2e (реальный браузер + аккаунт провайдера)** в песочнице
   невозможен — проверены HTTP-контракты authorize/callback на живом serve и
   Device Flow целиком на fake-сервере. Реальный client_id GitHub-приложения
   opencode подставляется в `DeviceFlowConfig` при подключении (одна строка).
3. **Prompt-стрим без LLM-креденшиалов** не проверяет генерацию сообщений
   (сервер отвечает ошибкой провайдера) — механизм SSE-стрима покрыт
   server.connected/permission/question событиями и unit-редьюсером.
4. riverpod 3.5: family-arg передаётся в конструктор нотифаера, оверрайды —
   `overrideWith2`; тип Family-провайдера экспортируется из
   `flutter_riverpod/misc.dart` (зафиксировано в коде с комментарием).

## 4. Коммиты

- `5ad379e` — M3: авторизация (OAuth через API, Device Flow, TokenStore)
- `b2a6336` — M4: чат MVP (редьюсер, контроллер, UI, интеграционные)
- `d380fad` — восстановление дерева M0–M2 (песочница была пересоздана;
  дерево идентично `d5980a0` из tarball)

## 5. Как проверить локально

```bash
fvm flutter analyze && fvm flutter test
LIVE_BASE_URL=http://127.0.0.1:PORT LIVE_PASSWORD=... fvm flutter test --tags integration
```
