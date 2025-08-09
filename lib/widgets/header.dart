import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/onboarding_data.dart';
import '../services/onboarding_service.dart';
import 'calendar_button.dart';
import 'tasks_button.dart';

class Header extends StatefulWidget {
  final List<Task> tasks;
  final VoidCallback? onTasksUpdated;

  const Header({super.key, required this.tasks, this.onTasksUpdated});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  TimeWindow? _planningWindow;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimeWindows();
  }

  Future<void> _loadTimeWindows() async {
    try {
      final onboardingData = await OnboardingService.getOnboardingData();
      setState(() {
        _planningWindow = onboardingData?.planningWindow;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CalendarButton(),
          // Time window display
          Container(
            width: 160,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF8B5CF6),
                        ),
                      ),
                    )
                  : Text(
                      _planningWindow != null
                          ? '${_planningWindow!.startTime.format(context)} - ${_planningWindow!.endTime.format(context)}'
                          : 'Set Time Window',
                      style: const TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
          TasksButton(
            tasks: widget.tasks,
            onTasksUpdated: widget.onTasksUpdated,
          ),
        ],
      ),
    );
  }
}
