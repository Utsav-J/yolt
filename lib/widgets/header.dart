import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/tasks_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample tasks for navigation (replace with provider/state management in real app)
    final List<Task> _tasks = [
      Task(
        id: '1',
        title: 'Complete project presentation',
        description: 'Prepare slides for the quarterly review meeting',
        isCompleted: false,
        priority: TaskPriority.high,
        dueDate: DateTime.now().add(const Duration(days: 2)),
      ),
      Task(
        id: '2',
        title: 'Daily meditation',
        description: '15 minutes of mindfulness practice',
        isCompleted: true,
        priority: TaskPriority.medium,
        dueDate: DateTime.now(),
      ),
      Task(
        id: '3',
        title: 'Grocery shopping',
        description: 'Buy ingredients for dinner tonight',
        isCompleted: false,
        priority: TaskPriority.low,
        dueDate: DateTime.now().add(const Duration(hours: 3)),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Calendar icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Color(0xFF8B5CF6),
              size: 24,
            ),
          ),

          // Streak counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Color(0xFFFF6B35),
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '25 days',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Tasks button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TasksScreen(tasks: _tasks),
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
          ),
        ],
      ),
    );
  }
}
