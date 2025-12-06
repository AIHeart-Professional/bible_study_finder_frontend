import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'core/router/navbar.dart';
import 'core/logging/logger.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_mode.dart';
import 'services/notification/notification_service.dart';
import 'core/theme/theme_provider.dart';

// Background message handler (must be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final logger = getLogger('BackgroundMessageHandler');
  logger.debug('Handling background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    final logger = getLogger('Main');
    logger.info('Firebase initialized successfully');
    
    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    final logger = getLogger('Main');
    logger.error('Error initializing Firebase', error: e);
  }

  // Initialize logger
  BibleStudyLogger.initialize(
    logLevel: AppConfig.isDebugMode ? LogLevel.debug : LogLevel.info,
    consoleOutput: true,
    fileOutput: false, // Set to true and provide logFilePath if you want file logging
    // logFilePath: 'logs/bible_study_frontend.log', // Uncomment for file logging
  );

  // Initialize notification service
  await NotificationService.initialize();

  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Bible Study Finder',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: _getThemeMode(themeProvider.themeMode),
            home: const MainNavigator(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  /// Convert AppThemeMode to Flutter's ThemeMode
  ThemeMode _getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}