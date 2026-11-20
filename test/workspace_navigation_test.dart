import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pocketforge/app/app.dart';
import 'package:pocketforge/features/onboarding/onboarding_store.dart';

class _MemoryOnboardingStore extends OnboardingStore {
  _MemoryOnboardingStore({this.completed = false});

  bool completed;

  @override
  Future<bool> isComplete() async => completed;

  @override
  Future<void> complete() async {
    completed = true;
  }
}

void main() {
  const sandbox = MethodChannel('pocketforge/sandbox');
  final calls = <String>[];
  late String phase;

  setUp(() {
    calls.clear();
    phase = 'uninitialized';
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sandbox, (call) async {
          calls.add(call.method);
          if (call.method == 'status') {
            return {
              'phase': phase,
              'progress': 0.25,
              'healthy': phase == 'ready',
            };
          }
          if (call.method == 'exec') {
            return {'code': 0, 'stdout': 'sample-workspace'};
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sandbox, null);
  });

  Future<void> openApp(WidgetTester tester, OnboardingStore store) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [onboardingStoreProvider.overrideWithValue(store)],
        child: const PocketForgeApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('знакомство пропускается и не запускает загрузку', (
    tester,
  ) async {
    final store = _MemoryOnboardingStore();
    await openApp(tester, store);
    expect(find.text('Локальная среда разработки на Android'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(calls, isEmpty);

    await tester.tap(find.text('Пропустить'));
    await tester.pumpAndSettle();
    expect(store.completed, isTrue);
    expect(find.text('Рабочая среда'), findsOneWidget);
    expect(calls, isNot(contains('start')));

    await tester.pumpWidget(const SizedBox.shrink());
    await openApp(tester, store);
    expect(find.text('Рабочая среда'), findsOneWidget);
    expect(find.text('Пропустить'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('рабочие вкладки доступны до запуска без обращения к API', (
    tester,
  ) async {
    await openApp(tester, _MemoryOnboardingStore(completed: true));
    final navigation = find.byType(NavigationBar);
    for (final tab in ['Чат', 'Git', 'Терминал']) {
      await tester.tap(
        find.descendant(of: navigation, matching: find.text(tab)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Нужна песочница'), findsOneWidget);
      expect(calls, isNot(contains('connectionPassword')));
    }
    await tester.tap(find.text('К обзору'));
    await tester.pumpAndSettle();
    expect(find.text('Рабочая среда'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('нативная фаза загрузки показывает прогресс вместо ошибки', (
    tester,
  ) async {
    phase = 'downloading_opencode';
    await openApp(tester, _MemoryOnboardingStore(completed: true));
    expect(find.text('Загружаем OpenCode'), findsOneWidget);
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, 0.25);
    expect(find.text('Запустить песочницу'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('сброс вынесен в диагностику и требует подтверждения', (
    tester,
  ) async {
    await openApp(tester, _MemoryOnboardingStore(completed: true));
    expect(find.text('Сбросить песочницу'), findsNothing);
    final diagnostics = find.text('Диагностика песочницы');
    await tester.ensureVisible(diagnostics);
    await tester.tap(diagnostics);
    await tester.pumpAndSettle();

    final reset = find.text('Сбросить песочницу');
    await tester.ensureVisible(reset);
    await tester.tap(reset);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(calls, isNot(contains('reset')));

    await tester.tap(reset);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить данные'));
    await tester.pumpAndSettle();
    expect(calls.where((method) => method == 'reset'), hasLength(1));
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('вывод терминала сохраняется при переключении вкладки', (
    tester,
  ) async {
    phase = 'ready';
    await openApp(tester, _MemoryOnboardingStore(completed: true));
    final navigation = find.byType(NavigationBar);
    final terminal = find.descendant(
      of: navigation,
      matching: find.text('Терминал'),
    );
    await tester.tap(terminal);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'ls workspace');
    await tester.tap(find.byTooltip('Выполнить команду'));
    await tester.pumpAndSettle();
    final output = find.byWidgetPredicate(
      (widget) =>
          widget is SelectableText &&
          widget.data?.contains('sample-workspace') == true,
    );
    expect(output, findsOneWidget);

    await tester.tap(
      find.descendant(of: navigation, matching: find.text('Обзор')),
    );
    await tester.pumpAndSettle();
    await tester.tap(terminal);
    await tester.pumpAndSettle();
    expect(output, findsOneWidget);
    expect(calls.where((method) => method == 'exec'), hasLength(1));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
