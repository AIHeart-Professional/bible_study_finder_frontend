import 'dart:io';
import 'package:flutter/foundation.dart';

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
  // Check for environment variable (set via --dart-define in Codemagic)
  static const String environment = String.fromEnvironment(
    'APP_ENVIRONMENT',
    defaultValue: 'development', // 'development', 'staging', 'production'
  );
  
  // Debug mode: false in production, true otherwise
  static bool get isDebugMode {
    const String env = String.fromEnvironment(
      'APP_ENVIRONMENT',
      defaultValue: 'development',
    );
    return env != 'production';
  }
  
  // API Configuration
  static const String bibleApiUrl = 'https://api.scripture.api.bible/v1';
  static const String bibleApiKey = 'd91bb5cc08f6b1625b9c8fc4f47e8d4e';
  
  // Backend API Configuration
  // Priority: Environment variable (for production builds) > Platform-specific defaults
  // For Codemagic builds, set BACKEND_API_URL via --dart-define
  // For Android emulator: use 10.0.2.2 (maps to host machine's localhost)
  // For iOS simulator: use localhost
  // For web: use localhost
  // For physical devices: use your machine's IP address on local network
  static String get backendApiUrl {
    // Check for environment variable first (set via --dart-define in Codemagic)
    const String envApiUrl = String.fromEnvironment(
      'BACKEND_API_URL',
      defaultValue: '',
    );
    
    // If environment variable is set, use it (for production builds)
    if (envApiUrl.isNotEmpty) {
      return envApiUrl;
    }
    
    // Fall back to platform-specific localhost URLs for local development
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      // Android emulator uses 10.0.2.2 to access host machine's localhost
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      // iOS simulator can use localhost
      return 'http://localhost:8000';
    } else {
      // Desktop or other platforms
      return 'http://localhost:8000';
    }
  }
  
  static const String backendApiVersion = '';
  
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
  
  /// Get the backend API URL for logging/debugging
  static String getBackendApiUrlForLogging() => backendApiUrl;
}














