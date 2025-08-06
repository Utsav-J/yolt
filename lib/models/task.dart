// lib/models/task.dart
import 'dart:convert';

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

  // Add JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.toString().split('.').last,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
      ),
      dueDate: DateTime.parse(json['dueDate']),
    );
  }
}

enum TaskPriority { high, medium, low }
