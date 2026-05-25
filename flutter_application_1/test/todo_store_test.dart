import 'package:flutter/material.dart' show TextDirection;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/api/todo_api.dart';
import 'package:flutter_application_1/api/token_store.dart';
import 'package:flutter_application_1/models/models.dart';
import 'package:flutter_application_1/state/todo_store.dart';

class _MemoryTokenStore extends TokenStore {
  StoredSession? _session;

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String username,
    required int userId,
  }) async {
    _session = StoredSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: username,
      userId: userId,
    );
  }

  @override
  Future<StoredSession?> readSession() async => _session;

  @override
  Future<void> clear() async {
    _session = null;
  }
}

class _FakeTodoApi extends TodoApi {
  _FakeTodoApi() : super(baseUrl: 'http://localhost');

  @override
  Future<void> register({
    required String username,
    required String password,
  }) async {
    // always succeed
  }

  @override
  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    if (username.trim() != 'demo@todo.app' || password != '123456') {
      throw TodoApiException('Login failed.', statusCode: 401);
    }
    return const AuthSession(
      accessToken: 'access',
      refreshToken: 'refresh',
      userId: 1,
      username: 'demo@todo.app',
    );
  }

  @override
  Future<List<ApiTask>> myTasks({required String accessToken}) async {
    return const <ApiTask>[];
  }

  @override
  Future<ApiTask?> createTask({
    required String accessToken,
    required String title,
    required String description,
  }) async {
    return ApiTask(
      id: 1,
      title: title,
      description: description,
      createdAtRaw: '',
      imagePath: null,
    );
  }

  @override
  Future<void> updateTask({
    required String accessToken,
    required int id,
    required String title,
    required String description,
  }) async {
    // always succeed
  }

  @override
  Future<void> deleteTask({required String accessToken, required int id}) async {
    // always succeed
  }
}

TaskDraft buildDraft({
  String title = 'Plan sprint review',
  String description = 'Prepare summary and action items.',
  TaskCategory category = TaskCategory.work,
  TaskPriority priority = TaskPriority.medium,
  TaskStatus status = TaskStatus.todo,
  DateTime? dueAt,
}) {
  return TaskDraft(
    title: title,
    description: description,
    category: category,
    priority: priority,
    status: status,
    dueAt: dueAt ?? DateTime(2026, 4, 25, 10, 30),
  );
}

void main() {
  group('TodoStore', () {
    test(
      'starts on welcome route and switches text direction with language',
      () {
        final TodoStore store = TodoStore(
          api: _FakeTodoApi(),
          tokenStore: _MemoryTokenStore(),
        );

        expect(store.currentRoute.screen, AppScreen.welcome);
        expect(store.textDirection, TextDirection.ltr);

        store.setLanguage(AppLanguage.arabic);

        expect(store.language, AppLanguage.arabic);
        expect(store.textDirection, TextDirection.rtl);
      },
    );

    test('register updates profile and navigates login', () async {
      final TodoStore store = TodoStore(
        api: _FakeTodoApi(),
        tokenStore: _MemoryTokenStore(),
      );

      final bool ok = await store.register(
        fullName: '  Marwa Ali  ',
        email: '  marwa@example.com ',
        phone: ' 01001234567 ',
        password: 'secret1',
      );

      expect(ok, isTrue);
      expect(store.currentRoute.screen, AppScreen.login);
      expect(store.profile.fullName, 'Marwa Ali');
      expect(store.profile.email, 'marwa@example.com');
      expect(store.profile.phone, '01001234567');
      expect(store.matchesPassword('secret1'), isTrue);
    });

    test('login rejects wrong credentials and accepts valid ones', () async {
      final TodoStore store = TodoStore(
        api: _FakeTodoApi(),
        tokenStore: _MemoryTokenStore(),
      );

      expect(
        await store.login(email: 'demo@todo.app', password: 'wrong-password'),
        isFalse,
      );
      expect(store.currentRoute.screen, AppScreen.welcome);

      expect(await store.login(email: 'demo@todo.app', password: '123456'), isTrue);
      expect(store.currentRoute.screen, AppScreen.home);
    });

    test('can add, update, cycle, and delete tasks', () async {
      final TodoStore store = TodoStore(
        api: _FakeTodoApi(),
        tokenStore: _MemoryTokenStore(),
      );

      await store.addTask(buildDraft());

      expect(store.totalTasks, 1);
      final String taskId = store.tasks.single.id;
      expect(store.taskById(taskId).status, TaskStatus.todo);

      store.cycleTaskStatus(taskId);
      expect(store.taskById(taskId).status, TaskStatus.inProgress);

      await store.updateTask(
        taskId,
        buildDraft(
          title: 'Updated title',
          description: 'Updated description',
          category: TaskCategory.study,
          priority: TaskPriority.high,
          status: TaskStatus.done,
          dueAt: DateTime(2026, 4, 26, 8, 0),
        ),
      );

      final TaskItem updatedTask = store.taskById(taskId);
      expect(updatedTask.title, 'Updated title');
      expect(updatedTask.description, 'Updated description');
      expect(updatedTask.category, TaskCategory.study);
      expect(updatedTask.priority, TaskPriority.high);
      expect(updatedTask.status, TaskStatus.done);

      await store.deleteTask(taskId);

      expect(store.totalTasks, 0);
      expect(store.tasks, isEmpty);
    });

    test('logout returns to the welcome screen', () async {
      final TodoStore store = TodoStore(
        api: _FakeTodoApi(),
        tokenStore: _MemoryTokenStore(),
      );

      await store.login(email: 'demo@todo.app', password: '123456');
      expect(store.currentRoute.screen, AppScreen.home);

      await store.logout();

      expect(store.currentRoute.screen, AppScreen.welcome);
    });
  });
}
