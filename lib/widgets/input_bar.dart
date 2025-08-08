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
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                  color: Color.fromARGB(120, 0, 0, 0),
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
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.7),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.mic, color: Color(0xFF8B5CF6), size: 22),
            ),
          ),
        ),
      ],
    );
  }
}
