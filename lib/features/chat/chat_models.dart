import 'package:flutter/foundation.dart';

/// Вид части сообщения чата — толерантный к v1/v2-формам.
@immutable
class ChatPartView {

  /// Создаёт часть.
  const ChatPartView({
    required this.id,
    required this.kind,
    this.text = '',
    this.toolName,
    this.toolStatus,
    this.toolTitle,
    this.fileName,
    this.mime,
    this.url,
  });
  /// Собирает часть из сырого JSON (типы: text/reasoning/tool/file).
  factory ChatPartView.fromMap(Map<String, Object?> p) {
    final stateRaw = p['state'];
    final state = stateRaw is Map ? stateRaw.cast<String, Object?>() : null;
    final statusRaw = state?['status'];
    var status = statusRaw is String ? statusRaw : null;
    final titleRaw = state?['title'];
    final title = titleRaw is String ? titleRaw : null;
    if (status == null && state?['output'] != null) status = 'completed';
    final typeRaw = p['type'];
    final type = typeRaw is String ? typeRaw : 'other';
    final idRaw = p['id'] ?? p['callID'];
    final textRaw = p['text'];
    final toolRaw = p['tool'];
    final meta = p['meta'];
    final fileRaw = p['filename'] ?? (meta is Map ? meta['filename'] : null);
    final mimeRaw = p['mime'];
    final urlRaw = p['url'];
    return ChatPartView(
      id: idRaw is String ? idRaw : '',
      kind: switch (type) {
        'text' => 'text',
        'reasoning' => 'reasoning',
        'tool' => 'tool',
        'file' => 'file',
        _ => 'other',
      },
      text: textRaw is String ? textRaw : '',
      toolName: toolRaw is String ? toolRaw : null,
      toolStatus: status,
      toolTitle: title,
      fileName: fileRaw is String ? fileRaw : null,
      mime: mimeRaw is String ? mimeRaw : null,
      url: urlRaw is String ? urlRaw : null,
    );
  }

  /// Идентификатор части (prt_...).
  final String id;

  /// text | reasoning | tool | file | other.
  final String kind;

  /// Текст для text/reasoning.
  final String text;

  /// Имя инструмента для tool.
  final String? toolName;

  /// pending | running | completed | error.
  final String? toolStatus;

  /// Заголовок вызова инструмента (title из state).
  final String? toolTitle;

  /// Имя файла для file.
  final String? fileName;

  /// MIME для file.
  final String? mime;

  /// URL/data-URL для file.
  final String? url;

  /// Применяет обновление части (merge по id).
  ChatPartView merge(ChatPartView update) => update;
}

/// Вид сообщения чата.
@immutable
class ChatMessageView {

  /// Создаёт сообщение.
  const ChatMessageView({
    required this.id,
    required this.role,
    required this.parts,
    this.timeCreated,
  });
  /// Собирает сообщение из сырого JSON {id, role, parts, time}.
  factory ChatMessageView.fromMap(Map<String, Object?> m) {
    final parts = <ChatPartView>[];
    final raw = m['parts'];
    if (raw is List) {
      for (final p in raw) {
        if (p is Map) {
          parts.add(
            ChatPartView.fromMap(Map<String, Object?>.from(p)),
          );
        }
      }
    }
    final timeRaw = m['time'];
    final time = timeRaw is Map ? timeRaw.cast<String, Object?>() : null;
    final idRaw = m['id'];
    final roleRaw = m['role'];
    return ChatMessageView(
      id: idRaw is String ? idRaw : '',
      role: roleRaw is String ? roleRaw : 'assistant',
      parts: parts,
      timeCreated: time?['created'] as num?,
    );
  }

  /// Идентификатор (msg_...).
  final String id;

  /// user | assistant.
  final String role;

  /// Части в порядке следования.
  final List<ChatPartView> parts;

  /// Время создания (epoch ms/с — как отдал сервер).
  final num? timeCreated;

  /// Обновляет сообщение (замена целиком по id).
  ChatMessageView merge(ChatMessageView update) => update;

  /// Заменяет/добавляет часть по id.
  ChatMessageView upsertPart(ChatPartView part) {
    final next = List<ChatPartView>.from(parts);
    final idx = next.indexWhere((p) => p.id == part.id);
    if (idx >= 0) {
      next[idx] = part;
    } else {
      next.add(part);
    }
    return ChatMessageView(
      id: id,
      role: role,
      parts: next,
      timeCreated: timeCreated,
    );
  }
}

/// Состояние чата сессии.
@immutable
class ChatState {
  /// Создаёт состояние.
  const ChatState({
    required this.messages,
    this.streaming = false,
    this.permissions = const [],
    this.questions = const [],
    this.error,
  });

  /// Сообщения в порядке следования.
  final List<ChatMessageView> messages;

  /// Идёт генерация (ждём session.idle).
  final bool streaming;

  /// Активные запросы разрешения (raw maps).
  final List<Map<String, Object?>> permissions;

  /// Активные вопросы (raw maps).
  final List<Map<String, Object?>> questions;

  /// Последняя ошибка сессии.
  final String? error;

  /// Обновляет список сообщений.
  ChatState withMessages(List<ChatMessageView> messages) => ChatState(
        messages: messages,
        streaming: streaming,
        permissions: permissions,
        questions: questions,
        error: error,
      );
}

/// Редьюсер SSE-событий → [ChatState].
///
/// Толерантен к обеим формам обёртки: payload берётся из
/// `data` (V2) либо `properties` (v1), иначе — сам фрейм.
class ChatEventReducer {
  /// Применяет фрейм к состоянию; возвращает новое состояние
  /// или null, если событие не влияет на чат.
  ChatState? apply(ChatState state, Map<String, Object?> frame) {
    final type = frame['type'] as String?;
    final raw = frame['data'] ?? frame['properties'] ?? frame;
    if (raw is! Map) return null;
    final payload = Map<String, Object?>.from(raw);

    switch (type) {
      case 'message.updated':
        final info = payload['info'];
        if (info is! Map) return null;
        return state.withMessages(
          _upsert(state.messages, Map<String, Object?>.from(info)),
        );
      case 'message.part.updated':
        final partRaw = payload['part'];
        if (partRaw is! Map) return null;
        final part = Map<String, Object?>.from(partRaw);
        final messageID = part['messageID'] ?? payload['messageID'];
        if (messageID is! String) return null;
        final view = ChatPartView.fromMap(part);
        return state.withMessages(
          _upsertPart(state.messages, messageID, view),
        );
      case 'message.removed':
        final messageID = payload['messageID'];
        if (messageID is! String) return null;
        return state.withMessages(
          state.messages.where((m) => m.id != messageID).toList(),
        );
      case 'permission.updated':
      case 'permission.asked':
        final id = payload['id'] ?? payload['permissionID'];
        if (id is! String) return null;
        final list = List<Map<String, Object?>>.from(state.permissions)
          ..removeWhere(
            (e) => (e['id'] ?? e['permissionID']) == id,
          )
          ..add(payload);
        return _with(state, permissions: list);
      case 'permission.replied':
        final id = payload['permissionID'] ?? payload['id'];
        if (id is! String) return null;
        final list = state.permissions
            .where((e) => (e['id'] ?? e['permissionID']) != id)
            .toList();
        return _with(state, permissions: list);
      case 'question.asked':
      case 'question.updated':
        final id = payload['id'] ?? payload['requestID'];
        if (id is! String) return null;
        final list = List<Map<String, Object?>>.from(state.questions)
          ..removeWhere(
            (e) => (e['id'] ?? e['requestID']) == id,
          )
          ..add(payload);
        return _with(state, questions: list);
      case 'question.replied':
      case 'question.rejected':
        final id = payload['requestID'] ?? payload['id'];
        if (id is! String) return null;
        final list = state.questions
            .where((e) => (e['id'] ?? e['requestID']) != id)
            .toList();
        return _with(state, questions: list);
      case 'session.idle':
        return _with(state, streaming: false);
      case 'session.error':
        // error бывает и Map {message: …} (v2), и просто строкой (v1) —
        // каст as Map ронял обработчик TypeError'ом, и ошибка сессии
        // не доходила до пользователя.
        final errRaw = payload['error'];
        final err = errRaw is Map
            ? errRaw['message'] ?? payload['message']
            : errRaw ?? payload['message'];
        return _with(
          state,
          streaming: false,
          error: err is String ? err : 'Ошибка сессии',
        );
      default:
        return null;
    }
  }
}

/// Копирует состояние с заменой отдельных полей.
ChatState _with(
  ChatState state, {
  List<ChatMessageView>? messages,
  bool? streaming,
  List<Map<String, Object?>>? permissions,
  List<Map<String, Object?>>? questions,
  String? error,
  bool clearError = false,
}) {
  return ChatState(
    messages: messages ?? state.messages,
    streaming: streaming ?? state.streaming,
    permissions: permissions ?? state.permissions,
    questions: questions ?? state.questions,
    error: clearError
        ? null
        : (error ?? state.error),
  );
}

List<ChatMessageView> _upsert(
  List<ChatMessageView> list,
  Map<String, Object?> info,
) {
  final view = ChatMessageView.fromMap(info);
  final next = List<ChatMessageView>.from(list);
  final idx = next.indexWhere((m) => m.id == view.id);
  if (idx < 0) {
    next.add(view);
    return next;
  }
  final old = next[idx];
  // v1-форма message.updated несёт только info, без parts: без этого
  // merge'а metadata-апдейт затирал уже накопленные части (текст,
  // tool-карточки) пустым сообщением.
  next[idx] = view.parts.isEmpty && old.parts.isNotEmpty
      ? ChatMessageView(
          id: old.id,
          role: view.role,
          parts: old.parts,
          timeCreated: view.timeCreated ?? old.timeCreated,
        )
      : view;
  return next;
}

List<ChatMessageView> _upsertPart(
  List<ChatMessageView> list,
  String messageID,
  ChatPartView part,
) {
  final next = List<ChatMessageView>.from(list);
  final idx = next.indexWhere((m) => m.id == messageID);
  if (idx >= 0) {
    next[idx] = next[idx].upsertPart(part);
  } else {
    next.add(
      ChatMessageView(id: messageID, role: 'assistant', parts: [part]),
    );
  }
  return next;
}
