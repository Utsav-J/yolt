import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/tasks_screen.dart';

class TasksButton extends StatelessWidget {
  final List<Task> tasks;

  const TasksButton({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksScreen(tasks: tasks),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.task_alt,
          color: Color(0xFF8B5CF6),
          size: 24,
        ),
      ),
    );
  }
} 