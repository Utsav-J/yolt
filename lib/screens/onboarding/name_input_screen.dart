import 'package:flutter/material.dart';

class NameInputScreen extends StatelessWidget {
  final String? userName;
  final Function(String?) onNameChanged;
  final VoidCallback onSkipName;

  const NameInputScreen({
    super.key,
    this.userName,
    required this.onNameChanged,
    required this.onSkipName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_2, color: Colors.white, size: 96),
          const SizedBox(height: 40),
          const Text(
            'What should we call you?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          TextField(
            onChanged: (value) {
              onNameChanged(value.trim().isEmpty ? null : value.trim());
            },
            style: const TextStyle(fontSize: 18, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter your name',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onSkipName,
            child: const Text(
              'Rather not say',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
