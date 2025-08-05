// lib/models/task.dart

class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final TaskPriority priority;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.dueDate,
  });
}

enum TaskPriority { high, medium, low }
