import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/core/api/opencode_client.dart';
import 'package:pocketforge/features/chat/chat_controller.dart';
import 'package:pocketforge/features/chat/chat_page.dart';

class CannedAdapter implements HttpClientAdapter {
  CannedAdapter({this.onCall, this.pending = const []});

  final void Function(RequestOptions options)? onCall;
  final List<RequestOptions> calls = [];
  final List<Map<String, Object?>> pending;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options);
    onCall?.call(options);
    return ResponseBody.fromString(
      jsonEncode(_responseFor(options)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  Object? _responseFor(RequestOptions options) {
    final path = options.path;
    if (path == '/permission' || path == '/question') return pending;
    if (path.startsWith('/question/') && options.method == 'POST') return true;
    if (path.contains('/message') && options.method == 'GET') {
      return const <Object>[];
    }
    if (path.contains('/message') && options.method == 'POST') {
      return {
        'info': {'id': 'msg_srv', 'role': 'assistant'},
        'parts': const <Object>[],
      };
    }
    return const <Object>[];
  }
}

void main() {
  test('контроллер: история + события SSE → состояние чата', () async {
    final adapter = CannedAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final client = OpenCodeClient(
      baseUrl: 'http://127.0.0.1:4096',
      password: 'x',
      dio: dio,
    );
    final events = StreamController<Map<String, Object?>>.broadcast();
    final container = ProviderContainer(
      overrides: [
        chatClientProvider.overrideWithValue(client),
        rawEventsProvider.overrideWithValue(events.stream),
      ],
    );
    addTearDown(container.dispose);

    final initial = await container.read(
      chatControllerProvider('ses_1').future,
    );
    expect(initial.messages, isEmpty);

    events
      ..add({
        'type': 'message.updated',
        'data': {
          'info': {
            'id': 'msg_1',
            'sessionID': 'ses_1',
            'role': 'user',
            'parts': [
              {'type': 'text', 'text': 'Привет'},
            ],
          },
        },
      })
      ..add({
        'type': 'message.part.updated',
        'data': {
          'part': {
            'id': 'prt_1',
            'sessionID': 'ses_1',
            'messageID': 'msg_1',
            'type': 'text',
            'text': 'Привет',
          },
        },
      });
    await Future<void>.delayed(const Duration(milliseconds: 50));
    var state = container.read(chatControllerProvider('ses_1')).value!;
    expect(state.messages, hasLength(1));
    expect(state.messages[0].parts[0].text, 'Привет');

    // Событие чужой сессии игнорируется.
    events.add({
      'type': 'message.updated',
      'data': {
        'info': {
          'id': 'msg_other',
          'sessionID': 'ses_2',
          'role': 'assistant',
          'parts': const <Object>[],
        },
      },
    });
    await Future<void>.delayed(const Duration(milliseconds: 50));
    state = container.read(chatControllerProvider('ses_1')).value!;
    expect(state.messages, hasLength(1));

    // send(): POST /session/{id}/message с parts.
    await container.read(chatControllerProvider('ses_1').notifier).send('hi');
    final post = adapter.calls
        .where((c) => c.method == 'POST' && c.path.contains('/message'))
        .toList();
    expect(post, isNotEmpty);
    expect(post.first.path, '/session/ses_1/message');
    final body =
        (post.first.data! as Map).cast<String, Object?>();
    final parts =
        (body['parts']! as List<Object?>).cast<Map<String, Object?>>();
    expect(parts.first['type'], 'text');
    expect(parts.first['text'], 'hi');

    state = container.read(chatControllerProvider('ses_1')).value!;
    expect(state.streaming, isFalse);
    expect(state.messages.last.id, 'msg_srv');

    // streaming сбрасывается по session.idle.
    events.add({
      'type': 'session.idle',
      'data': {'sessionID': 'ses_1'},
    });
    await Future<void>.delayed(const Duration(milliseconds: 50));
    state = container.read(chatControllerProvider('ses_1')).value!;
    expect(state.streaming, isFalse);
  });

  test('запросы из истории и SSE ограничены текущей сессией', () async {
    final adapter = CannedAdapter(
      pending: [
        for (final (session, suffix) in [
          ('ses_1', 'local'),
          ('ses_2', 'foreign'),
        ])
          {
            'sessionID': session,
            'id': 'per_$suffix',
            'permission': 'edit',
            'patterns': ['*.dart'],
            'metadata': <String, Object?>{},
            'always': <String>[],
            'questions': <Object>[],
          },
      ],
    );
    final client = OpenCodeClient(
      baseUrl: 'http://127.0.0.1:4096',
      password: 'x',
      dio: Dio()..httpClientAdapter = adapter,
    );
    final events = StreamController<Map<String, Object?>>.broadcast();
    final container = ProviderContainer(
      overrides: [
        chatClientProvider.overrideWithValue(client),
        rawEventsProvider.overrideWithValue(events.stream),
      ],
    );
    addTearDown(events.close);
    addTearDown(container.dispose);

    final provider = chatControllerProvider('ses_1');
    final initial = await container.read(provider.future);
    expect(initial.permissions.map((e) => e['id']), ['per_local']);
    expect(initial.questions.map((e) => e['id']), ['per_local']);

    events.add({
      'type': 'message.part.updated',
      'data': {
        'part': {
          'id': 'prt_foreign',
          'sessionID': 'ses_2',
          'messageID': 'msg_foreign',
          'type': 'text',
          'text': 'Другая сессия',
        },
      },
    });
    await Future<void>.delayed(Duration.zero);
    expect(container.read(provider).value!.messages, isEmpty);
  });

  testWidgets('карточка отправляет ответы на все вопросы одним запросом', (
    tester,
  ) async {
    final adapter = CannedAdapter();
    final client = OpenCodeClient(
      baseUrl: 'http://127.0.0.1:4096',
      password: 'x',
      dio: Dio()..httpClientAdapter = adapter,
    );
    final events = StreamController<Map<String, Object?>>.broadcast();
    addTearDown(events.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatClientProvider.overrideWithValue(client),
          rawEventsProvider.overrideWithValue(events.stream),
        ],
        child: const MaterialApp(
          home: ChatPage(sessionID: 'ses_1', onNewSession: null),
        ),
      ),
    );
    await tester.pumpAndSettle();
    events.add({
      'type': 'question.asked',
      'data': {
        'id': 'que_1',
        'sessionID': 'ses_1',
        'questions': [
          {
            'question': 'Формат',
            'options': [
              {'label': 'JSON'},
              {'label': 'YAML'},
            ],
          },
          {
            'question': 'Проверки',
            'multiple': true,
            'options': [
              {'label': 'Анализ'},
              {'label': 'Тесты'},
            ],
          },
        ],
      },
    });
    await tester.pumpAndSettle();
    await tester.tap(find.text('JSON'));
    await tester.pumpAndSettle();
    expect(adapter.calls.where((call) => call.method == 'POST'), isEmpty);

    await tester.tap(find.text('Анализ'));
    await tester.tap(find.text('Тесты'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ответить'));
    await tester.pumpAndSettle();

    final reply = adapter.calls.singleWhere((call) => call.method == 'POST');
    expect(reply.path, '/question/que_1/reply');
    expect((reply.data as Map)['answers'], [
      ['JSON'],
      ['Анализ', 'Тесты'],
    ]);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('interrupt и permissionReply уходят на нужные эндпоинты', () async {
    final adapter = CannedAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final client = OpenCodeClient(
      baseUrl: 'http://127.0.0.1:4096',
      password: 'x',
      dio: dio,
    );
    final events = StreamController<Map<String, Object?>>.broadcast();
    final container = ProviderContainer(
      overrides: [
        chatClientProvider.overrideWithValue(client),
        rawEventsProvider.overrideWithValue(events.stream),
      ],
    );
    addTearDown(container.dispose);
    await container.read(chatControllerProvider('ses_1').future);

    await container
        .read(chatControllerProvider('ses_1').notifier)
        .interrupt();
    expect(
      adapter.calls.any(
        (c) => c.method == 'POST' && c.path.contains('/interrupt'),
      ),
      isTrue,
    );

    await container
        .read(chatControllerProvider('ses_1').notifier)
        .replyPermission('per_9', 'always');
    final reply = adapter.calls
        .firstWhere((c) => c.path.contains('/permission/per_9/reply'));
    expect((reply.data as Map)['reply'], 'always');
  });
}
