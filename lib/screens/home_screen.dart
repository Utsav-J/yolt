import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/header.dart';
import '../widgets/backdrop_greeting.dart';
import '../widgets/welcome_message.dart';
import '../widgets/info_cards.dart';
import '../widgets/input_section.dart';
import 'dart:convert'; // Added for json
import 'package:http/http.dart' as http; // Added for http

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
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  // Sample tasks
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

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeAnimations();
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

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF3E8FF), // Light purple
              Color(0xFFFFF7ED), // Light peach
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Backdrop "Good Morning" text
              const BackdropGreeting(),

              // Main content
              Column(
                children: [
                  const Header(),
                  const WelcomeMessage(),
                  const InfoCards(),
                  const Spacer(),
                  InputSection(
                    isListening: _isListening,
                    textController: _textController,
                    startListening: _startListening,
                    stopListening: _stopListening,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
