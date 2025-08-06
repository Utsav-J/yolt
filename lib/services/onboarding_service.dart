import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/onboarding_data.dart';

class OnboardingService {
  static const String _onboardingCompleteKey = 'onboardingComplete';
  static const String _onboardingDataKey = 'onboardingData';

  // Check if onboarding is completed
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  // Mark onboarding as complete
  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  // Save onboarding data
  static Future<void> saveOnboardingData(OnboardingData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(data.toJson());
    await prefs.setString(_onboardingDataKey, jsonString);
  }

  // Get onboarding data
  static Future<OnboardingData?> getOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_onboardingDataKey);

    if (jsonString == null) return null;

    try {
      final jsonData = json.decode(jsonString);
      return OnboardingData.fromJson(jsonData);
    } catch (e) {
      print('Error parsing onboarding data: $e');
      return null;
    }
  }

  // Clear onboarding data (for testing or reset)
  static Future<void> clearOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompleteKey);
    await prefs.remove(_onboardingDataKey);
  }

  // Reset onboarding (for testing purposes)
  static Future<void> resetOnboarding() async {
    await clearOnboardingData();
  }
}
