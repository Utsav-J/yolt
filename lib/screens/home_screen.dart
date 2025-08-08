import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/header.dart';
import '../widgets/welcome_message.dart';
import '../widgets/info_cards.dart';
import '../widgets/input_section.dart';
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
  late AnimationController _pulseController;
  late AnimationController _glowController;

  // Dynamic tasks list
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeAnimations();
    _loadTasks();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  void _initializeSpeech() async {
    // Mock speech recognition initialization
    _speechEnabled = true;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
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

    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);

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
    _pulseController.stop();
    _glowController.stop();
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
      await _callExtractTasksFromTextAPI(input);
      // API Endpoint Placeholders
      await _callTaskCreationAPI(input);
      await _callAnalyticsAPI(input);
      await _callUserEngagementAPI(input);

      _textController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task added successfully!'),
          backgroundColor: Colors.green,
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
        Uri.parse(
          'https://221899cefcee.ngrok-free.app/extract-tasks-from-text',
        ),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
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
        Uri.parse('https://your-api.com/api/tasks/create'),
        headers: {'Content-Type': 'application/json'},
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
        Uri.parse('https://your-api.com/api/analytics/user-input'),
        headers: {'Content-Type': 'application/json'},
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
        Uri.parse('https://your-api.com/api/engagement/record'),
        headers: {'Content-Type': 'application/json'},
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 224, 203, 246), // Light purple
              Color.fromARGB(255, 250, 224, 193), // Light peach
            ],
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
                      Header(tasks: _tasks),
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
