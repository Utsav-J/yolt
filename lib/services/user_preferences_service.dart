import 'package:flutter/material.dart';
import '../models/onboarding_data.dart';
import 'onboarding_service.dart';

class UserPreferencesService {
  static OnboardingData? _cachedData;
  static bool _isInitialized = false;

  // Initialize the service and cache the data
  static Future<void> initialize() async {
    if (!_isInitialized) {
      _cachedData = await OnboardingService.getOnboardingData();
      _isInitialized = true;
    }
  }

  // Get user name
  static String? getUserName() {
    return _cachedData?.userName;
  }

  // Get planning time window
  static TimeWindow? getPlanningTimeWindow() {
    return _cachedData?.planningWindow;
  }

  // Get reflection time window
  static TimeWindow? getReflectionTimeWindow() {
    return _cachedData?.reflectionWindow;
  }

  // Get all user preferences
  static OnboardingData? getAllPreferences() {
    return _cachedData;
  }

  // Refresh cached data
  static Future<void> refreshData() async {
    _cachedData = await OnboardingService.getOnboardingData();
  }

  // Check if user has completed onboarding
  static Future<bool> hasCompletedOnboarding() async {
    return await OnboardingService.isOnboardingComplete();
  }

  // Clear all user preferences
  static Future<void> clearPreferences() async {
    await OnboardingService.clearOnboardingData();
    _cachedData = null;
    _isInitialized = false;
  }

  // Test method to verify storage is working
  static Future<void> testStorage() async {
    print('Testing SharedPreferences storage...');

    // Test data
    final testData = OnboardingData(
      userName: 'Test User',
      planningWindow: TimeWindow(
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
      ),
      reflectionWindow: TimeWindow(
        startTime: const TimeOfDay(hour: 20, minute: 0),
        endTime: const TimeOfDay(hour: 22, minute: 0),
      ),
    );

    // Save test data
    await OnboardingService.saveOnboardingData(testData);
    print('Test data saved');

    // Retrieve test data
    final retrievedData = await OnboardingService.getOnboardingData();
    print('Retrieved data: ${retrievedData?.userName}');
    if (retrievedData != null && retrievedData.planningWindow != null) {
      print(
        'Planning window: ${retrievedData.planningWindow.startTime.hour}:${retrievedData.planningWindow.startTime.minute.toString().padLeft(2, '0')} - ${retrievedData.planningWindow.endTime.hour}:${retrievedData.planningWindow.endTime.minute.toString().padLeft(2, '0')}',
      );
    }
    if (retrievedData != null && retrievedData.reflectionWindow != null) {
      print(
        'Reflection window: ${retrievedData.reflectionWindow.startTime.hour}:${retrievedData.reflectionWindow.startTime.minute.toString().padLeft(2, '0')} - ${retrievedData.reflectionWindow.endTime.hour}:${retrievedData.reflectionWindow.endTime.minute.toString().padLeft(2, '0')}',
      );
    }

    // Clear test data
    await OnboardingService.clearOnboardingData();
    print('Test data cleared');
  }
}
