import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketforge/features/git/git_service.dart';

/// Провайдер GitService (переопределяется в тестах).
final gitServiceProvider = Provider<GitService>(
  (_) => throw UnimplementedError(),
);

/// Отложенное git-действие для git-агента в чате.
///
/// GitPage кладёт промпт. Пользователь проверяет его в чате перед отправкой.
class PendingGitAction extends Notifier<String?> {
  /// Загрузка: ничего не отложено.
  @override
  String? build() => null;

  /// Отложить промпт (или сбросить через null).
  void submit(String? value) {
    if (state != value) state = value;
  }
}

/// Провайдер отложенного git-действия.
final pendingGitActionProvider = NotifierProvider<PendingGitAction, String?>(
  PendingGitAction.new,
);

/// Состояние экрана git.
class GitState {
  /// Создаёт состояние.
  const GitState({
    required this.workDir,
    this.overview,
    this.diff,
    this.busy = false,
    this.message,
    this.error,
  });

  /// Каталог репозитория.
  final String workDir;

  /// Сводка.
  final GitOverview? overview;

  /// Дифф (последний загруженный).
  final List<(String, String)>? diff;

  /// Выполняется загрузка.
  final bool busy;

  /// Информационное сообщение.
  final String? message;

  /// Ошибка.
  final String? error;

  /// Копирует с заменой полей.
  GitState copyWith({
    String? workDir,
    GitOverview? overview,
    List<(String, String)>? diff,
    bool? busy,
    String? message,
    String? error,
    bool clearMessage = false,
    bool clearError = false,
  }) {
    return GitState(
      workDir: workDir ?? this.workDir,
      overview: overview ?? this.overview,
      diff: diff ?? this.diff,
      busy: busy ?? this.busy,
      message: clearMessage ? null : (message ?? this.message),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Контроллер git-экрана (read-only данные + передача мутаций агенту).
class GitController extends AsyncNotifier<GitState> {
  @override
  FutureOr<GitState> build() {
    final service = ref.watch(gitServiceProvider);
    return _load(service.workDir);
  }

  Future<GitState> _load(String dir) async {
    final service = ref.read(gitServiceProvider)..workDir = dir;
    try {
      final overview = await service.overview();
      return GitState(workDir: dir, overview: overview);
    } on Exception catch (e) {
      return GitState(workDir: dir, error: e.toString());
    }
  }

  /// Обновляет данные.
  Future<void> refresh() async {
    final cur = state.value;
    if (cur == null || cur.busy) {
      // Повторный вызов (RefreshIndicator + кнопка в AppBar) раньше
      // сбрасывал busy первым завершившимся, пока второй ещё работал.
      return;
    }
    state = AsyncValue<GitState>.data(
      cur.copyWith(busy: true, clearError: true),
    );
    final fresh = await _load(cur.workDir);
    state = AsyncValue<GitState>.data(fresh.copyWith(busy: false));
  }

  /// Меняет каталог репозитория.
  Future<void> setWorkDir(String dir) async {
    state = AsyncValue<GitState>.data(GitState(workDir: dir, busy: true));
    final fresh = await _load(dir);
    state = AsyncValue<GitState>.data(fresh.copyWith(busy: false));
  }

  /// Загружает дифф.
  Future<void> loadDiff() async {
    final cur = state.value;
    if (cur == null) return;
    try {
      final patches = await ref.read(gitServiceProvider).diff();
      state = AsyncValue<GitState>.data(
        cur.copyWith(diff: [for (final p in patches) (p.file, p.patch ?? '')]),
      );
    } on Exception catch (e) {
      state = AsyncValue<GitState>.data(cur.copyWith(error: e.toString()));
    }
  }

  /// Мутация через git-агента: кладёт промпт в pending и сообщает.
  ///
  /// Возвращает текст сообщения пользователю; переход в чат выполняет UI.
  String requestAgentAction(String prompt) {
    ref.read(pendingGitActionProvider.notifier).submit(prompt);
    return 'Черновик подготовлен';
  }

  /// Промпт git-агенту: клонирование репозитория.
  String clonePrompt(String url) =>
      ref.read(gitServiceProvider).promptClone(url);

  /// Промпт git-агенту: pull.
  String pullPrompt() => ref.read(gitServiceProvider).promptPull();

  /// Промпт git-агенту: push.
  String pushPrompt() => ref.read(gitServiceProvider).promptPush();

  /// Промпт git-агенту: смена ветки.
  String checkoutPrompt(String branch) =>
      ref.read(gitServiceProvider).promptCheckout(branch);

  /// Промпт git-агенту: коммит.
  String commitPrompt(String message) =>
      ref.read(gitServiceProvider).promptCommit(message);
}

/// Провайдер git-контроллера.
final gitControllerProvider = AsyncNotifierProvider<GitController, GitState>(
  GitController.new,
);
