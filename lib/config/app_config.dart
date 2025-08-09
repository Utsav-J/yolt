import 'dart:ui';

/// Centralized configuration file for the YOLT Task Tracker app
/// Contains all constants, URLs, and configuration settings
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // =============================================================================
  // API CONFIGURATION
  // =============================================================================

  /// Base URL for the main API (ngrok tunnel)
  /// Update this when the ngrok tunnel changes
  static const String baseUrl = 'https://e35f9e802329.ngrok-free.app';
  static const Color headerIconColor = Color(0xFF8B5CF6);

  /// Alternative base URL for production/secondary APIs
  static const String secondaryBaseUrl = 'https://your-api.com';

  // API Endpoints
  static const String extractTasksEndpoint = '/extract-tasks-from-text';
  static const String createTaskEndpoint = '/api/tasks/create';
  static const String analyticsEndpoint = '/api/analytics/user-input';
  static const String engagementEndpoint = '/api/engagement/record';
  static const String affirmationEndpoint = '/generate-affirmation';

  // Complete API URLs
  static String get extractTasksUrl => '$baseUrl$extractTasksEndpoint';
  static String get createTaskUrl => '$secondaryBaseUrl$createTaskEndpoint';
  static String get analyticsUrl => '$secondaryBaseUrl$analyticsEndpoint';
  static String get engagementUrl => '$secondaryBaseUrl$engagementEndpoint';
  static String get affirmationUrl => '$baseUrl$affirmationEndpoint';

  // =============================================================================
  // APP CONSTANTS
  // =============================================================================

  /// App display name
  static const String appName = 'YOLT Task Tracker';

  /// App version
  static const String appVersion = '1.0.0';

  /// App primary color
  static const int primaryColorValue = 0xFF8B5CF6;

  // =============================================================================
  // TIMING CONSTANTS
  // =============================================================================

  /// Default API timeout duration in seconds
  static const int apiTimeoutSeconds = 30;

  /// Default delay for loading states (milliseconds)
  static const int loadingDelayMs = 200;

  /// Minimum time between affirmation fetches (hours)
  static const int affirmationCooldownHours = 24;

  /// Mock speech recognition duration (seconds)
  static const int mockSpeechDurationSeconds = 3;

  // =============================================================================
  // UI CONSTANTS
  // =============================================================================

  /// Default border radius for cards and containers
  static const double defaultBorderRadius = 16.0;

  /// Default padding for screen content
  static const double defaultPadding = 20.0;

  /// Default spacing between elements
  static const double defaultSpacing = 16.0;

  /// Maximum task title length
  static const int maxTaskTitleLength = 100;

  /// Maximum task description length
  static const int maxTaskDescriptionLength = 500;

  // =============================================================================
  // STORAGE KEYS
  // =============================================================================

  /// SharedPreferences key for onboarding completion status
  static const String onboardingCompleteKey = 'onboardingComplete';

  /// SharedPreferences key for onboarding data
  static const String onboardingDataKey = 'onboardingData';

  /// SharedPreferences key for user tasks
  static const String userTasksKey = 'user_tasks';

  /// SharedPreferences key for last affirmation fetch
  static const String lastAffirmationFetchKey = 'last_affirmation_fetch';

  /// SharedPreferences key for current affirmation
  static const String currentAffirmationKey = 'current_affirmation';

  /// SharedPreferences key for affirmation timestamp
  static const String affirmationTimestampKey = 'affirmation_timestamp';

  /// SharedPreferences key for last error
  static const String lastErrorKey = 'last_error';

  // =============================================================================
  // FEATURE FLAGS
  // =============================================================================

  /// Enable/disable debug logging
  static const bool enableDebugLogging = true;

  /// Enable/disable mock data for development
  static const bool enableMockData = false;

  /// Enable/disable analytics tracking
  static const bool enableAnalytics = true;

  /// Enable/disable crash reporting
  static const bool enableCrashReporting = false;

  // =============================================================================
  // DEFAULT VALUES
  // =============================================================================

  /// Default planning time window start hour
  static const int defaultPlanningStartHour = 6;

  /// Default planning time window start minute
  static const int defaultPlanningStartMinute = 0;

  /// Default planning time window end hour
  static const int defaultPlanningEndHour = 9;

  /// Default planning time window end minute
  static const int defaultPlanningEndMinute = 0;

  /// Default reflection time window start hour
  static const int defaultReflectionStartHour = 19;

  /// Default reflection time window start minute
  static const int defaultReflectionStartMinute = 0;

  /// Default reflection time window end hour
  static const int defaultReflectionEndHour = 21;

  /// Default reflection time window end minute
  static const int defaultReflectionEndMinute = 0;

  /// Default affirmation text when service is unavailable
  static const String defaultAffirmation =
      'I embrace the quiet strength within me to navigate the day with grace and purpose.';

  // =============================================================================
  // HTTP HEADERS
  // =============================================================================

  /// Common HTTP headers for API requests
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Headers specifically for ngrok requests
  static const Map<String, String> ngrokHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  // =============================================================================
  // ENVIRONMENT HELPERS
  // =============================================================================

  /// Check if running in debug mode
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Get appropriate headers based on URL
  static Map<String, String> getHeadersForUrl(String url) {
    if (url.contains('ngrok')) {
      return ngrokHeaders;
    }
    return defaultHeaders;
  }
}
