import 'package:flutter/material.dart';
import 'package:yolt/config/app_config.dart';
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
            height: 48,
            width: 48,
            alignment: Alignment.center,
            // padding: const EdgeInsets.all(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
            child: pendingTasks > 0
                ? Text(
                    pendingTasks > 99 ? '99+' : pendingTasks.toString(),
                    style: const TextStyle(
                      color: AppConfig.headerIconColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Icon(
                    Icons.task_alt,
                    color: AppConfig.headerIconColor,
                    size: 24,
                  ),
          ),
        ],
      ),
    );
  }
}
