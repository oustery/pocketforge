import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Тип Family-провайдера экспортируется из misc.dart (см. riverpod 3.5).
import 'package:flutter_riverpod/misc.dart';
import 'package:pocketforge/core/api/models.gen.dart' hide Provider;
import 'package:pocketforge/core/api/opencode_client.dart';
import 'package:pocketforge/features/chat/chat_models.dart';

/// Провайдер клиента opencode (переопределяется в тестах).
final chatClientProvider =
    Provider<OpenCodeClient>((_) => throw UnimplementedError());

/// Поток сырых SSE-фреймов (переопределяется в тестах).
///
/// `eventsRaw()` отдаёт single-subscription стрим: второй живой
/// контроллер чата (family по sessionID) падал на повторном `.listen`
/// с StateError и оставлял новый чат навсегда в error-состоянии.
/// Шина рассылает один источник всем подписчикам.
final rawEventsProvider = Provider<Stream<Map<String, Object?>>>((ref) {
  final bus = StreamController<Map<String, Object?>>.broadcast();
  final sub = ref.watch(chatClientProvider).eventsRaw().listen(
        bus.add,
        onError: (Object _) {},
        cancelOnError: false,
      );
  ref.onDispose(() {
    unawaited(sub.cancel());
    unawaited(bus.close());
  });
  return bus.stream;
});

/// Список сессий (для drawer).
class SessionsState {
  /// Создаёт состояние списка сессий.
  const SessionsState({required this.sessions, this.activeId, this.error});

  /// Сессии, отсортированные по свежести.
  final List<Session> sessions;

  /// Активная сессия чата.
  final String? activeId;

  /// Ошибка.
  final String? error;
}

/// Контроллер списка сессий.
class SessionsController extends AsyncNotifier<SessionsState> {
  @override
  Future<SessionsState> build() async {
    try {
      final client = ref.watch(chatClientProvider);
      final list = await client.sessionList();
      final sorted = list.toList()
        ..sort(
          (a, b) => ((b.time['updated'] as num?) ?? 0)
              .compareTo((a.time['updated'] as num?) ?? 0),
        );
      return SessionsState(
        sessions: sorted,
        activeId: sorted.firstOrNull?.id,
      );
    } on Exception catch (e) {
      return SessionsState(sessions: const [], error: e.toString());
    }
  }

  /// Создаёт сессию и делает её активной.
  Future<void> newSession() async {
    final client = ref.read(chatClientProvider);
    final s = await client.sessionCreate();
    final cur = state.value;
    if (cur == null) {
      // Провайдер ещё грузится (после invalidate): не падаем на cur!,
      // а собираем состояние заново вокруг созданной сессии.
      state = AsyncValue<SessionsState>.data(
        SessionsState(sessions: <Session>[s], activeId: s.id),
      );
      return;
    }
    state = AsyncValue<SessionsState>.data(
      SessionsState(
        sessions: <Session>[s, ...cur.sessions],
        activeId: s.id,
        error: cur.error,
      ),
    );
  }

  /// Выбирает активную сессию.
  void select(String id) {
    final cur = state.value;
    if (cur == null) return;
    state = AsyncValue<SessionsState>.data(
      SessionsState(
        sessions: cur.sessions,
        activeId: id,
        error: cur.error,
      ),
    );
  }
}

/// Провайдер списка сессий.
final sessionsProvider =
    AsyncNotifierProvider<SessionsController, SessionsState>(
  SessionsController.new,
);

/// Состояние чата одной сессии.
/// riverpod 3.5: family-arg передаётся в конструктор.
class ChatController extends AsyncNotifier<ChatState> {
  /// Создаёт контроллер сессии [arg].
  ChatController(this.arg);

  /// Идентификатор сессии.
  final String arg;

  StreamSubscription<Map<String, Object?>>? _sub;
  final ChatEventReducer _reducer = ChatEventReducer();

  @override
  FutureOr<ChatState> build() {
    final client = ref.watch(chatClientProvider);
    ref.onDispose(() => _sub?.cancel());

    // Поток событий применяется только к своей сессии.
    unawaited(_sub?.cancel());
    final backlog = <Map<String, Object?>>[];
    _sub = ref.watch(rawEventsProvider).listen((frame) {
      // Начальная загрузка ещё не завершилась (state.value == null):
      // события буферизуем и отыгрываем после загрузки — иначе старт
      // генерации, session.error и permission.asked в первые секунды
      // молча терялись.
      if (state.value == null) {
        backlog.add(frame);
        return;
      }
      _applyFrame(frame);
    });

    return _load(arg, client).then((loaded) {
      var st = loaded;
      for (final frame in backlog) {
        st = _nextState(st, frame) ?? st;
      }
      backlog.clear();
      return st;
    });
  }

  /// Применяет фрейм к текущему состоянию нотифайера.
  void _applyFrame(Map<String, Object?> frame) {
    final cur = state.value;
    if (cur == null) return;
    final next = _nextState(cur, frame);
    if (next != null) {
      state = AsyncValue<ChatState>.data(next);
    }
  }

  /// Фильтр своей сессии + редьюсер; возвращает новое состояние или null.
  ChatState? _nextState(ChatState cur, Map<String, Object?> frame) {
    final type = frame['type'] as String?;
    if (type != null && type.startsWith('server.')) return null;
    final raw = frame['data'] ?? frame['properties'] ?? frame;
    if (raw is! Map) return null;
    final payload = Map<String, Object?>.from(raw);
    final info = payload['info'];
    final sessionID =
        (payload['sessionID'] ??
                (info is Map ? info['sessionID'] : null))
            as String?;
    if (sessionID != null && sessionID != arg) return null;
    return _reducer.apply(cur, frame);
  }

  Future<ChatState> _load(String sessionID, OpenCodeClient client) async {
    try {
      final history = await client.sessionMessages(sessionID: sessionID);
      final views = <ChatMessageView>[];
      for (final m in history) {
        try {
          // Формат истории: {info: <Message>, parts: [...]} — склеиваем.
          final info = (m['info'] as Map?)?.cast<String, Object?>() ?? m;
          final merged = Map<String, Object?>.from(info);
          final parts = m['parts'];
          if (parts is List) merged['parts'] = parts;
          views.add(ChatMessageView.fromMap(merged));
        } on Exception {
          // битое сообщение пропускаем
        }
      }
      final perms = await _loadList(() => client.permissionList());
      final quests = await _loadList(() => client.questionList());
      return ChatState(
        messages: views,
        permissions: perms,
        questions: quests,
      );
    } on Exception catch (e) {
      return ChatState(messages: const [], error: e.toString());
    }
  }

  Future<List<Map<String, Object?>>> _loadList(
    Future<Object?> Function() call,
  ) async {
    try {
      final res = await call();
      if (res is! List) return const [];
      final out = <Map<String, Object?>>[];
      for (final e in res) {
        if (e is Map) {
          out.add(Map<String, Object?>.from(e));
        } else if (e is PermissionRequest || e is QuestionRequest) {
          // Сгенерированный клиент возвращает типизированные модели:
          // приводим к raw-виду, который ждут редьюсер и карточки
          // (иначе списки разрешений/вопросов всегда пустые).
          final raw = e is PermissionRequest
              ? e.toJson()
              : (e as QuestionRequest).toJson();
          out.add(Map<String, Object?>.from(raw));
        }
      }
      return out;
    } on Exception {
      return const [];
    }
  }

  /// Отправляет промпт: текст (+ вложенные файлы).
  Future<void> send(
    String text, {
    List<Map<String, Object?>> extraParts = const [],
  }) async {
    final client = ref.read(chatClientProvider);
    final parts = <Map<String, Object?>>[
      {'type': 'text', 'text': text},
      ...extraParts,
    ];
    final cur = state.value;
    if (cur != null) {
      state = AsyncValue<ChatState>.data(
        ChatState(
          messages: cur.messages,
          streaming: true,
          permissions: cur.permissions,
          questions: cur.questions,
        ),
      );
    }
    try {
      await client.sessionPrompt(sessionID: arg, body: {'parts': parts});
    } on Exception catch (e) {
      final cur2 = state.value;
      if (cur2 != null) {
        state = AsyncValue<ChatState>.data(
          ChatState(
            messages: cur2.messages,
            permissions: cur2.permissions,
            questions: cur2.questions,
            error: e.toString(),
          ),
        );
      }
      rethrow;
    }
  }

  /// Вложение изображения как file-часть с data-URL.
  Map<String, Object?> buildImagePart(
    Uint8List bytes, {
    required String mime,
    required String filename,
  }) {
    return {
      'type': 'file',
      'mime': mime,
      'filename': filename,
      'url':
          'data:$mime;base64,${base64Encode(bytes)}',
    };
  }

  /// Прерывает генерацию.
  Future<void> interrupt() async {
    final client = ref.read(chatClientProvider);
    await client.v2SessionInterrupt(sessionID: arg);
  }

  /// Ответ на запрос разрешения: once | always | reject.
  Future<void> replyPermission(
    String requestID,
    String reply, {
    String? message,
  }) async {
    final client = ref.read(chatClientProvider);
    await client.permissionReply(
      requestID: requestID,
      body: {'reply': reply, 'message': ?message},
    );
  }

  /// Ответ на вопрос (варианты по каждому вопросу).
  Future<void> replyQuestion(
    String requestID,
    List<List<String>> answers,
  ) async {
    final client = ref.read(chatClientProvider);
    await client.questionReply(
      requestID: requestID,
      body: {'answers': answers},
    );
  }

  /// Отклоняет вопрос.
  Future<void> rejectQuestion(String requestID) async {
    final client = ref.read(chatClientProvider);
    await client.questionReject(requestID: requestID);
  }
}

/// Провайдер чата (family по sessionID).
final AsyncNotifierProviderFamily<ChatController, ChatState, String>
    chatControllerProvider =
        AsyncNotifierProvider.family<ChatController, ChatState, String>(
          ChatController.new,
        );
