import 'package:flutter/material.dart';

class InputBar extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback startListening;
  final VoidCallback stopListening;

  const InputBar({
    super.key,
    required this.textController,
    required this.startListening,
    required this.stopListening,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Plus icon
          Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.add, color: Color(0xFF8B5CF6), size: 20),
          ),
          const SizedBox(width: 8),

          // Text input
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Share with Dot...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Microphone icon
          GestureDetector(
            onTapDown: (_) => startListening(),
            onTapUp: (_) => stopListening(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.mic, color: Color(0xFF8B5CF6), size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
