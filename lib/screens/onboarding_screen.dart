import 'package:flutter/material.dart';
import '../models/onboarding_data.dart';
import '../services/onboarding_service.dart';
import '../services/user_preferences_service.dart';
import 'home_screen.dart';
import 'onboarding/onboarding_screens.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding data
  String? _userName;
  TimeWindow? _planningWindow;
  TimeWindow? _reflectionWindow;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _canProceed() {
    // Only check requirements for the final screen (reflection time)
    if (_currentPage == 3) {
      return _reflectionWindow != null;
    }
    return true; // Allow swiping through first 3 screens
  }

  void _completeOnboarding() async {
    // Create onboarding data with default values if not set
    final onboardingData = OnboardingData(
      userName: _userName,
      planningWindow:
          _planningWindow ??
          TimeWindow(
            startTime: const TimeOfDay(hour: 6, minute: 0),
            endTime: const TimeOfDay(hour: 9, minute: 0),
          ),
      reflectionWindow:
          _reflectionWindow ??
          TimeWindow(
            startTime: const TimeOfDay(hour: 19, minute: 0),
            endTime: const TimeOfDay(hour: 21, minute: 0),
          ),
    );

    // Save data
    await OnboardingService.saveOnboardingData(onboardingData);
    await OnboardingService.markOnboardingComplete();

    // Initialize user preferences service with new data
    await UserPreferencesService.initialize();

    // Navigate to home screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TaskTrackerHomeScreen()),
      );
    }
  }

  // Get gradient based on current page
  LinearGradient _getGradientForPage(int page) {
    switch (page) {
      case 0: // Intro screen - Warm welcome gradient
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE0CBFF), // Light purple
            Color(0xFFFAE0C1), // Light peach
          ],
        );
      case 1: // Name input screen - Friendly blue gradient
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB), // Sky blue
            Color(0xFF98D8E8), // Light blue
          ],
        );
      case 2: // Planning time screen - Energetic orange gradient
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFB347), // Orange
            Color(0xFFFFD700), // Gold
          ],
        );
      case 3: // Reflection time screen - Calming purple gradient
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8B5CF6), // Purple
            Color(0xFFA78BFA), // Light purple
          ],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0CBFF), Color(0xFFFAE0C1)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(gradient: _getGradientForPage(_currentPage)),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index <= _currentPage
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // PageView content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    const IntroScreen(),
                    NameInputScreen(
                      userName: _userName,
                      onNameChanged: (name) {
                        setState(() {
                          _userName = name;
                        });
                      },
                      onSkipName: () {
                        setState(() {
                          _userName = null;
                        });
                        // Automatically advance to next screen
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    PlanningTimeScreen(
                      planningWindow: _planningWindow,
                      onPlanningWindowChanged: (window) {
                        setState(() {
                          _planningWindow = window;
                        });
                      },
                    ),
                    ReflectionTimeScreen(
                      reflectionWindow: _reflectionWindow,
                      onReflectionWindowChanged: (window) {
                        setState(() {
                          _reflectionWindow = window;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Bottom area - either Get Started button or spacer
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _currentPage == 3
                    ? Center(
                        child: GestureDetector(
                          onTap: _canProceed() ? _completeOnboarding : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: _canProceed()
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward,
                                  color: _canProceed()
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 56,
                      ), // Match the height of the Get Started button area
              ),
            ],
          ),
        ),
      ),
    );
  }
}
