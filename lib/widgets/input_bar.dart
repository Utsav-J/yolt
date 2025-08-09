import 'package:flutter/material.dart';

class InputBar extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback startListening;
  final VoidCallback stopListening;
  final ValueChanged<String> onSubmit;

  const InputBar({
    super.key,
    required this.textController,
    required this.startListening,
    required this.stopListening,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Rounded rectangle text input
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.45),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
            child: TextField(
              controller: textController,
              onSubmitted: onSubmit,
              decoration: const InputDecoration(
                hintText: 'What\'s in for today?',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color.fromARGB(200, 255, 255, 255),
                  fontSize: 16,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),

        const SizedBox(width: 12),

        GestureDetector(
          onTapDown: (_) => startListening(),
          onTapUp: (_) => stopListening(),
          child: Container(
            // width: 48,
            // height: 48,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.45),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.mic,
                color: Color.fromARGB(200, 255, 255, 255),
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
