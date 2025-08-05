import 'package:flutter/material.dart';

class BackdropGreeting extends StatelessWidget {
  const BackdropGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          'Good Morning',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.3),
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
