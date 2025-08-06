import 'package:flutter/material.dart';
import '../../models/onboarding_data.dart';

class PlanningTimeScreen extends StatelessWidget {
  final TimeWindow? planningWindow;
  final Function(TimeWindow) onPlanningWindowChanged;

  const PlanningTimeScreen({
    super.key,
    this.planningWindow,
    required this.onPlanningWindowChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Central sun-like icon with rays
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.schedule,
                        size: 60,
                        color: Color(0xFFFFB347),
                      ),
                    ),

                    // Decorative rays around the icon
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 50,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          width: 30,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // Main question text
                    const Text(
                      'When do you usually set your tasks for the day?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 60),

                    // Time selection section
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Start Time
                              Column(
                                children: [
                                  const Text(
                                    'START TIME',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime:
                                            planningWindow?.startTime ??
                                            const TimeOfDay(hour: 6, minute: 0),
                                      );
                                      if (time != null) {
                                        onPlanningWindowChanged(
                                          TimeWindow(
                                            startTime: time,
                                            endTime:
                                                planningWindow?.endTime ??
                                                const TimeOfDay(
                                                  hour: 9,
                                                  minute: 0,
                                                ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 13,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 5,
                                            offset: const Offset(0, -2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            planningWindow?.startTime.format(
                                                  context,
                                                ) ??
                                                '6:00 AM',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(width: 5),

                              // Separator
                              Container(
                                width: 1,
                                height: 80,
                                color: Colors.white.withOpacity(0.5),
                              ),

                              const SizedBox(width: 5),
                              // End Time
                              Column(
                                children: [
                                  const Text(
                                    'END TIME',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () async {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime:
                                            planningWindow?.endTime ??
                                            const TimeOfDay(hour: 9, minute: 0),
                                      );
                                      if (time != null) {
                                        onPlanningWindowChanged(
                                          TimeWindow(
                                            startTime:
                                                planningWindow?.startTime ??
                                                const TimeOfDay(
                                                  hour: 6,
                                                  minute: 0,
                                                ),
                                            endTime: time,
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 13,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 15,
                                            offset: const Offset(0, 8),
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 5,
                                            offset: const Offset(0, -2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            planningWindow?.endTime.format(
                                                  context,
                                                ) ??
                                                '9:00 AM',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Current selection display
                          if (planningWindow != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${planningWindow!.startTime.format(context)} - ${planningWindow!.endTime.format(context)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
