import 'package:flutter/material.dart';
import '../models/models.dart';

Color priorityColor(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return const Color(0xFFE45858);
    case TaskPriority.medium:
      return const Color(0xFFF3A63B);
    case TaskPriority.low:
      return const Color(0xFF3EA87A);
  }
}

Color categoryColor(TaskCategory category) {
  switch (category) {
    case TaskCategory.work:
      return const Color(0xFF2F7CF6);
    case TaskCategory.personal:
      return const Color(0xFFAA66E8);
    case TaskCategory.study:
      return const Color(0xFF0D8A6A);
  }
}

Color statusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.todo:
      return const Color(0xFF4B88FF);
    case TaskStatus.inProgress:
      return const Color(0xFFF09E32);
    case TaskStatus.done:
      return const Color(0xFF18A95D);
  }
}

IconData statusIcon(TaskStatus status) {
  switch (status) {
    case TaskStatus.todo:
      return Icons.radio_button_unchecked_rounded;
    case TaskStatus.inProgress:
      return Icons.timelapse_rounded;
    case TaskStatus.done:
      return Icons.check_circle_rounded;
  }
}

IconData cycleStatusIcon(TaskStatus status) {
  switch (status) {
    case TaskStatus.todo:
      return Icons.play_circle_outline_rounded;
    case TaskStatus.inProgress:
      return Icons.task_alt_rounded;
    case TaskStatus.done:
      return Icons.restart_alt_rounded;
  }
}

BoxDecoration softCardDecoration({Color color = Colors.white}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: const Color(0xFFDCECE3)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: const Color(0xFF143B2F).withValues(alpha: 0.06),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ],
  );
}
