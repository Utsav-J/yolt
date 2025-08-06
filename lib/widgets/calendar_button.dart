import 'package:flutter/material.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
} 