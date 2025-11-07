/// App Configuration
/// 
/// This file contains configuration values for the app including API keys,
/// endpoints, and environment-specific settings. 
/// 
/// WARNING: This is a temporary solution for development.
/// For production, these values should be:
/// - Loaded from environment variables
/// - Stored securely (e.g., using Flutter's secure storage)
/// - Managed via CI/CD pipelines or secrets management systems (e.g., OpenShift)
/// 
/// DO NOT commit sensitive data to version control.

class AppConfig {
  // Environment
  static const String environment = 'development'; // 'development', 'staging', 'production'
  static const bool isDebugMode = true;
  
  // API Configuration
  static const String bibleApiUrl = 'https://api.scripture.api.bible/v1';
  static const String bibleApiKey = 'd91bb5cc08f6b1625b9c8fc4f47e8d4e';
  
  // Backend API Configuration
  static const String backendApiUrl = 'http://localhost:8000';
  static const String backendApiVersion = '/api/v1';
  
  // Database Configuration (when implemented)
  static const String defaultDatabaseUrl = 'sqlite:///./bible_study.db';
  
  // App Configuration
  static const String appName = 'Bible Study Finder';
  static const String appVersion = '1.0.0';
  
  // Feature Flags
  static const bool enableCrashReporting = false;
  static const bool enableAnalytics = false;
  static const bool enableRemoteConfig = false;
  
  // Cache Settings
  static const int cacheExpirationHours = 24;
  static const int maxCacheSize = 50; // MB
  
  // API Timeout Settings
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 24);
  
  // Pagination Defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Search Settings
  static const int minSearchQueryLength = 2;
  static const int maxSearchResults = 50;
  
  // Localization
  static const String defaultLanguage = 'en';
  static const String defaultLocale = 'en_US';
  static const List<String> supportedLocales = ['en_US', 'es_ES'];
  
  // Helper Methods
  static String getBackendBaseUrl() => '$backendApiUrl$backendApiVersion';
  
  static bool isProduction() => environment == 'production';
  
  static bool isDevelopment() => environment == 'development';
  
  static Map<String, dynamic> getConfig() {
    return {
      'environment': environment,
      'isDebugMode': isDebugMode,
      'bibleApiUrl': bibleApiUrl,
      'backendApiUrl': backendApiUrl,
      'appName': appName,
      'appVersion': appVersion,
      'defaultLanguage': defaultLanguage,
    };
  }
}

