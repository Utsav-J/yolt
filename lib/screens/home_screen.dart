import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/header.dart';
import '../widgets/welcome_message.dart';
import '../widgets/info_cards.dart';
import '../widgets/input_section.dart';
import '../config/app_config.dart';
import 'dart:convert'; // Added for json
import 'package:http/http.dart' as http; // Added for http
import 'tasks_screen.dart';

class TaskTrackerHomeScreen extends StatefulWidget {
  const TaskTrackerHomeScreen({super.key});

  @override
  State<TaskTrackerHomeScreen> createState() => _TaskTrackerHomeScreenState();
}

class _TaskTrackerHomeScreenState extends State<TaskTrackerHomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isRecording = false;
  late AnimationController _animationController;
  late Animation<double> _breathingAnimation;

  // Dynamic tasks list
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeAnimation();
    _loadTasks();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(
        seconds: 4,
      ), // Faster breathing - more noticeable
      vsync: this,
    );

    _breathingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine, // Smoother, more natural breathing curve
      ),
    );

    _animationController.repeat(reverse: true);
  }

  void _initializeSpeech() async {
    // Mock speech recognition initialization
    _speechEnabled = true;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    // Initialize with sample tasks if none exist
    await TaskService.initializeWithSampleTasks();

    // Load current tasks
    final tasks = await TaskService.getCurrentTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _startListening() async {
    if (!_speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Speech recognition not available. Please use text input.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isListening = true;
      _isRecording = true;
    });

    // Mock speech recognition - simulate listening for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Mock recognized text
    const mockText = "Complete the project presentation by tomorrow";
    _textController.text = mockText;
    _stopListening();
    _processInput(mockText);
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _isRecording = false;
    });
  }

  void _processInput(String input) async {
    if (input.trim().isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processing your input...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Try API first
      bool apiSuccess = false;
      try {
        await _callExtractTasksFromTextAPI(input);
        apiSuccess = true;
      } catch (e) {
        print('API failed, creating local task: $e');
        // Create local task as fallback
        final fallbackTask = Task(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          title: input.trim(),
          description: 'Created locally when API was unavailable',
          isCompleted: false,
          priority: TaskPriority.medium,
          dueDate: DateTime.now().add(const Duration(days: 1)),
        );
        await TaskService.addTask(fallbackTask);
        await _loadTasks();
      }

      // Other API calls (non-critical)
      try {
        await _callTaskCreationAPI(input);
        await _callAnalyticsAPI(input);
        await _callUserEngagementAPI(input);
      } catch (e) {
        print('Non-critical API calls failed: $e');
      }

      _textController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            apiSuccess
                ? 'Task added successfully!'
                : 'Task created locally (API unavailable)',
          ),
          backgroundColor: apiSuccess ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _callExtractTasksFromTextAPI(String input) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.extractTasksUrl),
        headers: AppConfig.getHeadersForUrl(AppConfig.extractTasksUrl),
        body: json.encode({'text': input}),
      );

      // Print raw response
      // ignore: avoid_print
      print('extract-tasks-from-text: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        try {
          final decoded = json.decode(response.body) as Map<String, dynamic>;
          final tasksEnvelope = decoded['tasks'] as Map<String, dynamic>?;
          final List<dynamic> items =
              (tasksEnvelope != null ? tasksEnvelope['tasks'] : null)
                  as List<dynamic>? ??
              [];

          for (int i = 0; i < items.length; i++) {
            final item = items[i] as Map<String, dynamic>;
            final String title = (item['title'] ?? '').toString();
            if (title.isEmpty) continue;
            final String description = (item['description'] ?? '').toString();
            final String priorityStr = (item['priority'] ?? 'medium')
                .toString()
                .toLowerCase();

            TaskPriority priority;
            switch (priorityStr) {
              case 'high':
                priority = TaskPriority.high;
                break;
              case 'low':
                priority = TaskPriority.low;
                break;
              default:
                priority = TaskPriority.medium;
            }

            final task = Task(
              id: '${DateTime.now().microsecondsSinceEpoch}_$i',
              title: title,
              description: description == 'null' ? '' : description,
              isCompleted: false,
              priority: priority,
              dueDate: DateTime.now(),
            );

            await TaskService.addTask(task);
          }

          // Refresh local tasks after saving
          await _loadTasks();

          // After saving, navigate to TasksScreen with current tasks
          final currentTasks = await TaskService.getCurrentTasks();
          if (mounted) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TasksScreen(tasks: currentTasks),
              ),
            );
          }
        } catch (e) {
          // ignore: avoid_print
          print('Failed to parse tasks response: $e');
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error calling extract-tasks-from-text: $e');
    }
  }

  // API Endpoint Placeholders
  Future<void> _callTaskCreationAPI(String input) async {
    // POST /api/tasks/create
    try {
      final response = await http.post(
        Uri.parse(AppConfig.createTaskUrl),
        headers: AppConfig.getHeadersForUrl(AppConfig.createTaskUrl),
        body: json.encode({
          'title': input,
          'description': 'Created via voice/text input',
          'priority': 'medium',
          'dueDate': DateTime.now()
              .add(const Duration(days: 1))
              .toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        print('Task created:  {response.body}');
      }
    } catch (e) {
      print('Error creating task: $e');
    }
  }

  Future<void> _callAnalyticsAPI(String input) async {
    // POST /api/analytics/user-input
    try {
      await http.post(
        Uri.parse(AppConfig.analyticsUrl),
        headers: AppConfig.getHeadersForUrl(AppConfig.analyticsUrl),
        body: json.encode({
          'input': input,
          'inputType': _isRecording ? 'voice' : 'text',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    } catch (e) {
      print('Error sending analytics: $e');
    }
  }

  Future<void> _callUserEngagementAPI(String input) async {
    // POST /api/engagement/record
    try {
      await http.post(
        Uri.parse(AppConfig.engagementUrl),
        headers: AppConfig.getHeadersForUrl(AppConfig.engagementUrl),
        body: json.encode({
          'action': 'task_creation',
          'method': _isRecording ? 'voice' : 'text',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    } catch (e) {
      print('Error recording engagement: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final breathValue = _breathingAnimation.value;
    final xOffset =
        0.0 +
        (breathValue * 0.6 - 0.3); // Range: -0.3 to 0.3 (4x more movement)
    final yOffset =
        0.8 + (breathValue * 0.4 - 0.2); // Range: 0.6 to 1.0 (4x more movement)

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(xOffset, yOffset),
            radius: 1.2 + (breathValue * 0.8), // Dynamic radius: 1.2 to 2.0
            colors: const [
              Color(0xFFFF9A9A), // Soft coral/pink
              Color(0xFFE8A8C8), // Soft rose-pink (bridges coral to purple)
              Color(0xFFB19CD9), // Soft purple
              Color(0xFFD4C5E8), // Soft lavender (bridges purple to pink)
            ],
            stops: const [0, 0.3, 0.8, 1],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(tasks: _tasks, onTasksUpdated: _loadTasks),
                      const WelcomeMessage(),
                      const InfoCards(), // No longer needs tasks parameter
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: InputSection(
                  isListening: _isListening,
                  textController: _textController,
                  startListening: _startListening,
                  stopListening: _stopListening,
                  onSubmit: _processInput,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
