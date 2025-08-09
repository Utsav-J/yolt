import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/tasks_screen.dart';

class TasksButton extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback? onTasksUpdated;

  const TasksButton({super.key, required this.tasks, this.onTasksUpdated});

  @override
  Widget build(BuildContext context) {
    final pendingTasks = tasks.where((task) => !task.isCompleted).length;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TasksScreen(tasks: tasks)),
        );
        // Refresh tasks when returning from TasksScreen
        onTasksUpdated?.call();
      },
      child: Stack(
        children: [
          Container(
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
          if (pendingTasks > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  pendingTasks > 99 ? '99+' : pendingTasks.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
