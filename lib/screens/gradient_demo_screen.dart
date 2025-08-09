import 'package:flutter/material.dart';

class GradientDemoScreen extends StatefulWidget {
  const GradientDemoScreen({super.key});

  @override
  State<GradientDemoScreen> createState() => _GradientDemoScreenState();
}

class _GradientDemoScreenState extends State<GradientDemoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _breathingAnimation,
        builder: (context, child) {
          // Create breathing effect by subtly moving the center position
          final breathValue = _breathingAnimation.value;
          final xOffset =
              0.0 + (breathValue * 0.15 - 0.075); // Range: -0.075 to 0.075
          final yOffset =
              0.8 + (breathValue * 0.1 - 0.05); // Range: 0.75 to 0.85

          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(xOffset, yOffset),
                radius: 1.7,
                colors: const [
                  Color(0xFFFF9A9A), // Soft coral/pink
                  Color(0xFFE8A8C8), // Soft rose-pink (bridges coral to purple)
                  Color(0xFFB19CD9), // Soft purple
                  Color(0xFFD4C5E8), // Soft lavender (bridges purple to pink)
                ],
                stops: const [0.0, 0.3, 0.7, 0.95],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Main title
                  const Text(
                    'Introducing GPT-5',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'ChatGPT now has our smartest, fastest, most useful model yet,\nwith thinking built in — so you get the best answer, every time.',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ).withOpacity(0.8), // Medium purple
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
