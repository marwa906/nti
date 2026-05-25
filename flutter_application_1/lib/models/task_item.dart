import 'app_enums.dart';

// TaskDraft - Immutable task data for creating/editing tasks
class TaskDraft {
  const TaskDraft({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.dueAt,
  });

  final String title;
  final String description;
  final TaskCategory category;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime dueAt;
}

// TaskItem - Mutable task instance with ID
class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.dueAt,
  });

  final String id;
  String title;
  String description;
  TaskCategory category;
  TaskPriority priority;
  TaskStatus status;
  DateTime dueAt;
}
