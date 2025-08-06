import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'task_service.dart';

class AffirmationService {
  static const String _baseUrl = 'https://3e173188656f.ngrok-free.app';
  static const String _lastFetchKey = 'last_affirmation_fetch';
  static const String _currentAffirmationKey = 'current_affirmation';
  static const String _lastErrorKey = 'last_affirmation_error';

  // Check if we need to fetch a new affirmation (24-hour check)
  static Future<bool> shouldFetchNewAffirmation() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetch = prefs.getString(_lastFetchKey);

    if (lastFetch == null) return true;

    final lastFetchTime = DateTime.parse(lastFetch);
    final now = DateTime.now();
    final difference = now.difference(lastFetchTime);

    // Return true if more than 24 hours have passed
    return difference.inHours >= 24;
  }

  // Get current affirmation from SharedPreferences
  static Future<String?> getCurrentAffirmation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentAffirmationKey);
  }

  // Get last error message
  static Future<String?> getLastError() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastErrorKey);
  }

  // Check if server is reachable
  static Future<bool> isServerReachable() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/health'),
            headers: {'accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Fetch new affirmation from API using current tasks
  static Future<String?> fetchNewAffirmation() async {
    try {
      // Get current task titles from TaskService
      final taskTitles = await TaskService.getTaskTitles();

      // Check if server is reachable first
      final isReachable = await isServerReachable();
      if (!isReachable) {
        throw Exception(
          'Server is not reachable. Please check if your backend is running.',
        );
      }

      final response = await http
          .post(
            Uri.parse('$_baseUrl/generate-affirmation'),
            headers: {
              'Content-Type': 'application/json',
              'accept': 'application/json',
            },
            body: jsonEncode({'tasks': taskTitles.join('. ')}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['affirmation'] != null) {
          // Save the new affirmation and timestamp
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_currentAffirmationKey, data['affirmation']);
          await prefs.setString(
            _lastFetchKey,
            DateTime.now().toIso8601String(),
          );

          // Clear any previous error
          await prefs.remove(_lastErrorKey);

          return data['affirmation'];
        }
      }

      throw Exception('Failed to fetch affirmation: ${response.statusCode}');
    } catch (e) {
      // Save the error message for user feedback
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastErrorKey, e.toString());

      print('Error fetching affirmation: $e');
      return null;
    }
  }

  // Refresh affirmation (called on pull-to-refresh)
  static Future<String?> refreshAffirmation() async {
    // Always fetch new affirmation on manual refresh
    return await fetchNewAffirmation();
  }

  // Get affirmation for display (either cached or fetch new)
  static Future<String> getAffirmation() async {
    // Check if we should fetch a new affirmation
    if (await shouldFetchNewAffirmation()) {
      final newAffirmation = await fetchNewAffirmation();
      if (newAffirmation != null) {
        return newAffirmation;
      }
    }

    // Return cached affirmation or default
    final cachedAffirmation = await getCurrentAffirmation();
    return cachedAffirmation ??
        'I embrace the quiet strength within me to navigate the day with grace and purpose.';
  }

  // Get user-friendly error message
  static String getUserFriendlyErrorMessage(String error) {
    if (error.contains('Connection refused') ||
        error.contains('SocketException')) {
      return 'Unable to connect to the affirmation server. Please ensure your backend is running at http://127.0.0.1:8000';
    } else if (error.contains('timeout')) {
      return 'Request timed out. Please check your internet connection and try again.';
    } else if (error.contains('Failed to fetch affirmation')) {
      return 'Server returned an error. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
