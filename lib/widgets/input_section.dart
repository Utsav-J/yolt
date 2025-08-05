import 'package:flutter/material.dart';
import 'listening_state.dart';
import 'input_bar.dart';

class InputSection extends StatelessWidget {
  final bool isListening;
  final TextEditingController textController;
  final VoidCallback startListening;
  final VoidCallback stopListening;

  const InputSection({
    super.key,
    required this.isListening,
    required this.textController,
    required this.startListening,
    required this.stopListening,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          isListening
              ? ListeningState(onStop: stopListening)
              : InputBar(
                  textController: textController,
                  startListening: startListening,
                  stopListening: stopListening,
                ),
        ],
      ),
    );
  }
}
