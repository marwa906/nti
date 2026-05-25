import '../../../models/models.dart';

sealed class TasksState {
  const TasksState({required this.tasks});

  final List<TaskItem> tasks;
}

final class TasksInitialState extends TasksState {
  const TasksInitialState({required super.tasks});
}

final class TasksLoadingState extends TasksState {
  const TasksLoadingState({required super.tasks});
}

final class TasksErrorState extends TasksState {
  const TasksErrorState({required super.tasks, required this.message});

  final String message;
}

