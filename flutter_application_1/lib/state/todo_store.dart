import 'package:flutter/material.dart';

import '../api/todo_api.dart';
import '../api/token_store.dart';
import '../models/models.dart';

class TodoStore extends ChangeNotifier {
  TodoStore({TodoApi? api, TokenStore? tokenStore})
    : _api = api ?? TodoApi(),
      _tokenStore = tokenStore ?? TokenStore(),
      profile = const UserProfile(
        fullName: 'Ahmed Sobier',
        email: 'demo@todo.app',
        phone: '+20 100 123 4567',
        location: 'Cairo, Egypt',
        bio: 'Small, clear steps make busy days feel lighter.',
      ),
      _password = '123456' {
    _stack.add(const AppRouteState(AppScreen.welcome));
  }

  // Navigation stack
  final List<AppRouteState> _stack = <AppRouteState>[];
  
  // Tasks list
  final List<TaskItem> _tasks = <TaskItem>[];
  
  // API and token storage
  final TodoApi _api;
  final TokenStore _tokenStore;
  
  // User profile
  UserProfile profile;
  
  // Password (local only)
  String _password;
  
  // App language
  AppLanguage language = AppLanguage.english;

  // Auth tokens
  String? _accessToken;
  String? _authErrorMessage;

  String? get authErrorMessage => _authErrorMessage;

  // Getters
  bool get isLoggedIn => _accessToken != null;

  AppRouteState get currentRoute => _stack.last;

  bool get canPop => _stack.length > 1;

  TextDirection get textDirection =>
      language == AppLanguage.arabic ? TextDirection.rtl : TextDirection.ltr;

  List<TaskItem> get tasks {
    final List<TaskItem> sorted = <TaskItem>[..._tasks]
      ..sort((TaskItem first, TaskItem second) {
        if (first.status == TaskStatus.done &&
            second.status != TaskStatus.done) {
          return 1;
        }
        if (first.status != TaskStatus.done &&
            second.status == TaskStatus.done) {
          return -1;
        }
        return first.dueAt.compareTo(second.dueAt);
      });
    return List<TaskItem>.unmodifiable(sorted);
  }

  int get totalTasks => _tasks.length;

  int get completedTasks =>
      _tasks.where((TaskItem task) => task.status == TaskStatus.done).length;

  int get activeTasks =>
      _tasks.where((TaskItem task) => task.status != TaskStatus.done).length;

  int get highPriorityTasks => _tasks
      .where(
        (TaskItem task) =>
            task.priority == TaskPriority.high &&
            task.status != TaskStatus.done,
      )
      .length;

  // Navigation methods
  void push(AppScreen screen, {String? taskId}) {
    _stack.add(AppRouteState(screen, taskId: taskId));
    notifyListeners();
  }

  void replaceTop(AppScreen screen, {String? taskId}) {
    if (_stack.isEmpty) {
      _stack.add(AppRouteState(screen, taskId: taskId));
    } else {
      _stack[_stack.length - 1] = AppRouteState(screen, taskId: taskId);
    }
    notifyListeners();
  }

  void pop() {
    if (!canPop) {
      return;
    }
    _stack.removeLast();
    notifyListeners();
  }

  // Bootstrap - restore stored session
  Future<void> bootstrap() async {
    final StoredSession? stored = await _tokenStore.readSession();
    if (stored == null) {
      return;
    }

    _accessToken = stored.accessToken;

    try {
      await refreshMyTasks();
      _stack
        ..clear()
        ..add(const AppRouteState(AppScreen.home));
      notifyListeners();
    } on TodoApiException {
      await logout();
    }
  }

  // Login
  Future<bool> login({required String email, required String password}) async {
    final String username = email.trim();
    try {
      final AuthSession session = await _api.login(
        username: username,
        password: password,
      );

      await _applySession(session, password: password);
      return true;
    } on TodoApiException catch (e) {
      final StringBuffer msg = StringBuffer(e.message);
      if (e.statusCode != null) {
        msg.write(' (code: ${e.statusCode})');
      }
      final String body = (e.responseBody ?? '').trim();
      if (body.isNotEmpty) {
        msg.write('\n$body');
      }
      _authErrorMessage = msg.toString();
      return false;
    }
  }

  Future<void> _applySession(AuthSession session, {required String password}) async {
    _accessToken = session.accessToken;
    _authErrorMessage = null;

    await _tokenStore.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      username: session.username,
      userId: session.userId,
    );

    profile = profile.copyWith(
      fullName: session.username,
      email: session.username,
    );
    _password = password;

    await refreshMyTasks();

    _stack
      ..clear()
      ..add(const AppRouteState(AppScreen.home));
    notifyListeners();
  }

  // Register
  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final String username = email.trim();
    try {
      await _api.register(username: username, password: password);
      _authErrorMessage = null;
      final AuthSession session = await _api.login(
        username: username,
        password: password,
      );
      profile = profile.copyWith(
        fullName: fullName.trim().isEmpty ? session.username : fullName.trim(),
        email: username,
        phone: phone.trim(),
      );
      await _applySession(session, password: password);
      return true;
    } on TodoApiException catch (e) {
      // If registration fails because the account already exists (or any other
      // reason), try logging in with the same credentials to get the user to
      // Home directly.
      try {
        final AuthSession session = await _api.login(
          username: username,
          password: password,
        );
        profile = profile.copyWith(
          fullName: fullName.trim().isEmpty ? session.username : fullName.trim(),
          email: username,
          phone: phone.trim(),
        );
        await _applySession(session, password: password);
        return true;
      } on TodoApiException {
        // Fall through to show the original registration error.
      }

      final StringBuffer msg = StringBuffer(e.message);
      if (e.statusCode != null) {
        msg.write(' (code: ${e.statusCode})');
      }
      final String body = (e.responseBody ?? '').trim();
      if (body.isNotEmpty) {
        msg.write('\n$body');
      }
      _authErrorMessage = msg.toString();
      return false;
    }
  }

  // Password check
  bool matchesPassword(String password) => password == _password;

  // Update password
  void updatePassword(String password) {
    _password = password;
    notifyListeners();
  }

  // Update profile
  void updateProfile({
    required String fullName,
    required String email,
    required String phone,
    required String location,
    required String bio,
  }) {
    profile = profile.copyWith(
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      location: location.trim(),
      bio: bio.trim(),
    );
    pop();
  }

  // Logout
  Future<void> logout() async {
    _accessToken = null;
    _tasks.clear();
    await _tokenStore.clear();
    _stack
      ..clear()
      ..add(const AppRouteState(AppScreen.welcome));
    notifyListeners();
  }

  // Set language
  void setLanguage(AppLanguage value) {
    if (value == language) {
      return;
    }
    language = value;
    notifyListeners();
  }

  // Get task by ID
  TaskItem taskById(String id) {
    return _tasks.firstWhere((TaskItem task) => task.id == id);
  }

  int? _remoteIdForTask(TaskItem task) => int.tryParse(task.id);

  // Parse API date
  DateTime _parseApiCreatedAt(String raw) {
    if (raw.isEmpty) {
      return DateTime.now();
    }

    final RegExpMatch? match = RegExp(
      r'^[A-Za-z]{3},\s+(\d{2})\s+([A-Za-z]{3})\s+(\d{4})\s+(\d{2}):(\d{2}):(\d{2})\s+GMT$',
    ).firstMatch(raw.trim());
    if (match == null) {
      return DateTime.now();
    }

    final int day = int.parse(match.group(1)!);
    final String monthAbbr = match.group(2)!;
    final int year = int.parse(match.group(3)!);
    final int hour = int.parse(match.group(4)!);
    final int minute = int.parse(match.group(5)!);
    final int second = int.parse(match.group(6)!);

    const Map<String, int> months = <String, int>{
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };

    final int? month = months[monthAbbr];
    if (month == null) {
      return DateTime.now();
    }

    return DateTime.utc(year, month, day, hour, minute, second).toLocal();
  }

  // Refresh tasks from API
  Future<void> refreshMyTasks() async {
    final String? token = _accessToken;
    if (token == null) {
      return;
    }
    final List<ApiTask> remote = await _api.myTasks(accessToken: token);
    _tasks
      ..clear()
      ..addAll(
        remote.map((ApiTask t) {
          return TaskItem(
            id: t.id.toString(),
            title: t.title,
            description: t.description,
            category: TaskCategory.personal,
            priority: TaskPriority.medium,
            status: TaskStatus.todo,
            dueAt: _parseApiCreatedAt(t.createdAtRaw),
          );
        }),
      );
    notifyListeners();
  }

  TaskItem _taskItemFromApi(ApiTask task) {
    return TaskItem(
      id: task.id.toString(),
      title: task.title,
      description: task.description,
      category: TaskCategory.personal,
      priority: TaskPriority.medium,
      status: TaskStatus.todo,
      dueAt: _parseApiCreatedAt(task.createdAtRaw),
    );
  }

  // Add new task
  Future<bool> addTask(TaskDraft draft) async {
    final String title = draft.title.trim();
    final String description = draft.description.trim();
    final String? token = _accessToken;

    if (token != null) {
      try {
        final ApiTask? remote = await _api.createTask(
          accessToken: token,
          title: title,
          description: description,
        );
        if (remote == null) {
          await refreshMyTasks();
        } else {
          _tasks.insert(0, _taskItemFromApi(remote));
        }
      } on TodoApiException {
        return false;
      }

      _stack
        ..clear()
        ..add(const AppRouteState(AppScreen.home));
      notifyListeners();
      return true;
    }

    _tasks.insert(
      0,
      TaskItem(
        id: 'task-${DateTime.now().microsecondsSinceEpoch}',
        title: title,
        description: description,
        category: draft.category,
        priority: draft.priority,
        status: draft.status,
        dueAt: draft.dueAt,
      ),
    );
    _stack
      ..clear()
      ..add(const AppRouteState(AppScreen.home));
    notifyListeners();
    return true;
  }

  // Update task
  Future<bool> updateTask(String id, TaskDraft draft) async {
    TaskItem task;
    try {
      task = taskById(id);
    } on StateError {
      return false;
    }

    final String oldTitle = task.title;
    final String oldDescription = task.description;
    final TaskCategory oldCategory = task.category;
    final TaskPriority oldPriority = task.priority;
    final TaskStatus oldStatus = task.status;
    final DateTime oldDueAt = task.dueAt;

    task
      ..title = draft.title.trim()
      ..description = draft.description.trim()
      ..category = draft.category
      ..priority = draft.priority
      ..status = draft.status
      ..dueAt = draft.dueAt;

    final int? remoteId = _remoteIdForTask(task);
    final String? token = _accessToken;
    if (remoteId != null && token != null) {
      try {
        await _api.updateTask(
          accessToken: token,
          id: remoteId,
          title: task.title,
          description: task.description,
        );
      } on TodoApiException {
        task
          ..title = oldTitle
          ..description = oldDescription
          ..category = oldCategory
          ..priority = oldPriority
          ..status = oldStatus
          ..dueAt = oldDueAt;
        notifyListeners();
        return false;
      }
    }

    _stack
      ..clear()
      ..add(const AppRouteState(AppScreen.home));
    notifyListeners();
    return true;
  }

  // Delete task
  Future<bool> deleteTask(String id) async {
    final TaskItem task = taskById(id);
    final int? remoteId = _remoteIdForTask(task);
    final String? token = _accessToken;
    if (remoteId != null && token != null) {
      try {
        await _api.deleteTask(accessToken: token, id: remoteId);
      } on TodoApiException {
        return false;
      }
    }
    _tasks.removeWhere((TaskItem task) => task.id == id);
    _stack
      ..clear()
      ..add(const AppRouteState(AppScreen.home));
    notifyListeners();
    return true;
  }

  // Cycle task status
  void cycleTaskStatus(String id) {
    final TaskItem task = taskById(id);
    task.status = switch (task.status) {
      TaskStatus.todo => TaskStatus.inProgress,
      TaskStatus.inProgress => TaskStatus.done,
      TaskStatus.done => TaskStatus.todo,
    };
    notifyListeners();
  }
}
