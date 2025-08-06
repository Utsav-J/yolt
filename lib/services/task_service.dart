import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskService {
  static const String _tasksKey = 'user_tasks';

  // Get all tasks
  static Future<List<Task>> getAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];

    return tasksJson.map((taskJson) {
      final taskMap = jsonDecode(taskJson);
      return Task.fromJson(taskMap);
    }).toList();
  }

  // Get current tasks (not completed)
  static Future<List<Task>> getCurrentTasks() async {
    final allTasks = await getAllTasks();
    return allTasks.where((task) => !task.isCompleted).toList();
  }

  // Get today's tasks
  static Future<List<Task>> getTodayTasks() async {
    final allTasks = await getAllTasks();
    final today = DateTime.now();

    return allTasks.where((task) {
      final taskDate = DateTime(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
      );
      final todayDate = DateTime(today.year, today.month, today.day);
      return taskDate.isAtSameMomentAs(todayDate);
    }).toList();
  }

  // Add a new task
  static Future<void> addTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getAllTasks();

    tasks.add(task);

    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  // Update a task
  static Future<void> updateTask(Task updatedTask) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getAllTasks();

    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;

      final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList(_tasksKey, tasksJson);
    }
  }

  // Delete a task
  static Future<void> deleteTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getAllTasks();

    tasks.removeWhere((task) => task.id == taskId);

    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  // Toggle task completion
  static Future<void> toggleTaskCompletion(String taskId) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((task) => task.id == taskId);

    if (index != -1) {
      final task = tasks[index];
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: !task.isCompleted,
        priority: task.priority,
        dueDate: task.dueDate,
      );

      await updateTask(updatedTask);
    }
  }

  // Get task titles for API calls
  static Future<List<String>> getTaskTitles() async {
    final currentTasks = await getCurrentTasks();
    return currentTasks.map((task) => task.title).toList();
  }

  // Initialize with sample tasks if no tasks exist
  static Future<void> initializeWithSampleTasks() async {
    final tasks = await getAllTasks();
    if (tasks.isEmpty) {
      final sampleTasks = [
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

      for (final task in sampleTasks) {
        await addTask(task);
      }
    }
  }
}
