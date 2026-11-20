import 'package:flutter_test/flutter_test.dart';
import 'package:pocketforge/features/chat/chat_models.dart';

ChatState _apply(ChatState s, Map<String, Object?> frame) =>
    ChatEventReducer().apply(s, frame)!;

void main() {
  group('ChatEventReducer', () {
    test('message.updated добавляет сообщение (v2: обёртка data)', () {
      final s = _apply(
        const ChatState(messages: []),
        {
          'type': 'message.updated',
          'data': {
            'info': {
              'id': 'msg_1',
              'role': 'user',
              'parts': [
                {'type': 'text', 'text': 'Привет'},
              ],
            },
          },
        },
      );
      expect(s.messages, hasLength(1));
      expect(s.messages[0].role, 'user');
      expect(s.messages[0].parts.first.text, 'Привет');
    });

    test('message.updated работает и с v1-обёрткой properties', () {
      final s = _apply(
        const ChatState(messages: []),
        {
          'type': 'message.updated',
          'properties': {
            'info': {
              'id': 'msg_v1',
              'role': 'assistant',
              'parts': [
                {'type': 'text', 'text': 'Ответ'},
              ],
            },
          },
        },
      );
      expect(s.messages, hasLength(1));
      expect(s.messages[0].parts.first.text, 'Ответ');
    });

    test('message.part.updated дописывает часть в сообщение', () {
      var s = const ChatState(messages: []);
      s = _apply(s, {
        'type': 'message.updated',
        'data': {
          'info': {
            'id': 'msg_2',
            'role': 'assistant',
            'parts': const <Object>[],
          },
        },
      });
      s = _apply(s, {
        'type': 'message.part.updated',
        'data': {
          'part': {
            'id': 'prt_1',
            'messageID': 'msg_2',
            'type': 'text',
            'text': 'Первая строка',
          },
        },
      });
      s = _apply(s, {
        'type': 'message.part.updated',
        'data': {
          'part': {
            'id': 'prt_1',
            'messageID': 'msg_2',
            'type': 'text',
            'text': 'Первая строка продолжение',
          },
        },
      });
      expect(s.messages, hasLength(1));
      expect(s.messages[0].parts, hasLength(1));
      expect(s.messages[0].parts[0].text, 'Первая строка продолжение');
    });

    test('tool-часть парсит статус и название', () {
      final s = _apply(
        const ChatState(messages: []),
        {
          'type': 'message.part.updated',
          'data': {
            'part': {
              'id': 'prt_t1',
              'messageID': 'msg_3',
              'type': 'tool',
              'tool': 'bash',
              'state': {'status': 'running', 'title': 'ls -la'},
            },
          },
        },
      );
      final part = s.messages[0].parts[0];
      expect(part.kind, 'tool');
      expect(part.toolName, 'bash');
      expect(part.toolStatus, 'running');
      expect(part.toolTitle, 'ls -la');
    });

    test('permission.updated → карточка, replied → удалена', () {
      var s = const ChatState(messages: []);
      s = _apply(s, {
        'type': 'permission.updated',
        'data': {
          'id': 'per_1',
          'permission': 'edit',
          'patterns': ['/root/**'],
        },
      });
      expect(s.permissions, hasLength(1));
      s = _apply(s, {
        'type': 'permission.replied',
        'data': {'permissionID': 'per_1'},
      });
      expect(s.permissions, isEmpty);
    });

    test('question.asked → карточка, replied → удалена', () {
      var s = const ChatState(messages: []);
      s = _apply(s, {
        'type': 'question.asked',
        'data': {
          'id': 'que_1',
          'questions': [
            {
              'message': 'Выберите модель?',
              'options': [
                {'label': 'claude'},
                {'label': 'gpt'},
              ],
            },
          ],
        },
      });
      expect(s.questions, hasLength(1));
      s = _apply(s, {
        'type': 'question.replied',
        'data': {'requestID': 'que_1'},
      });
      expect(s.questions, isEmpty);
    });

    test('session.idle сбрасывает streaming; error ставит ошибку', () {
      var s = const ChatState(messages: [], streaming: true);
      s = _apply(s, {
        'type': 'session.idle',
        'data': {'sessionID': 'ses_1'},
      });
      expect(s.streaming, isFalse);
      s = _apply(s, {
        'type': 'session.error',
        'data': {
          'error': {'message': 'Нет провайдера'},
        },
      });
      expect(s.error, 'Нет провайдера');
      expect(s.streaming, isFalse);
    });

    test('неизвестные типы не ломают состояние', () {
      const s = ChatState(messages: []);
      final next = ChatEventReducer().apply(
        s,
        {
          'type': 'server.connected',
          'data': <String, Object?>{},
        },
      );
      expect(next, isNull);
    });
  });
}
