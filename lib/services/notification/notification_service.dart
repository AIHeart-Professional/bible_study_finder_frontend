import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../utils/logger.dart';
import '../../utils/auth_storage.dart';
import '../../apis/users/users_api.dart';

class NotificationService {
  static final _logger = getLogger('NotificationService');
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      _logger.debug('NotificationService already initialized');
      return;
    }

    _logger.debug('Initializing NotificationService');
    try {
      await _requestPermission();
      await _initializeLocalNotifications();
      await _setupMessageHandlers();
      await _registerFCMToken();
      _initialized = true;
      _logger.info('NotificationService initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('Error initializing NotificationService', error: e, stackTrace: stackTrace);
    }
  }

  static Future<void> _requestPermission() async {
    _logger.debug('Requesting notification permissions');
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.info('User granted notification permissions');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      _logger.warning('User granted provisional notification permissions');
    } else {
      _logger.warning('User denied notification permissions');
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    _logger.debug('Initializing local notifications');
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    _logger.debug('Notification tapped: ${response.payload}');
    // Handle navigation based on payload
    // Example: Navigate to group chat if payload contains groupId
  }

  static Future<void> _setupMessageHandlers() async {
    _logger.debug('Setting up FCM message handlers');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages (when app is terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageOpened);

    // Handle notification when app is opened from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessageOpened(initialMessage);
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _logger.debug('Received foreground message: ${message.messageId}');
    await _showLocalNotification(message);
  }

  static void _handleBackgroundMessageOpened(RemoteMessage message) {
    _logger.debug('Notification opened app: ${message.messageId}');
    // Handle navigation to relevant screen
    // Example: Navigate to group detail page if message.data contains groupId
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      'group_chat_channel',
      'Group Chat Notifications',
      channelDescription: 'Notifications for new messages in groups',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  static Future<void> _registerFCMToken() async {
    _logger.debug('Registering FCM token with backend');
    try {
      final token = await _firebaseMessaging.getToken();
      if (token == null) {
        _logger.warning('FCM token is null');
        return;
      }

      // Debug: Print token for testing (remove in production)
      _logger.info('FCM Token: $token');
      debugPrint('🔔 FCM Token: $token'); // Shows in Flutter console

      final userId = await AuthStorage.getUserId();
      if (userId == null) {
        _logger.warning('User not logged in, cannot register FCM token');
        return;
      }

      final success = await UsersApi.registerFCMTokenApi(userId, token);
      if (success) {
        _logger.info('FCM token registered successfully');
      } else {
        _logger.warning('Failed to register FCM token');
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);
    } catch (e, stackTrace) {
      _logger.error('Error registering FCM token', error: e, stackTrace: stackTrace);
    }
  }

  static Future<void> _onTokenRefresh(String newToken) async {
    _logger.debug('FCM token refreshed');
    await _registerFCMToken();
  }

  static Future<void> unregisterFCMToken() async {
    _logger.debug('Unregistering FCM token');
    try {
      final userId = await AuthStorage.getUserId();
      if (userId == null) {
        _logger.warning('User not logged in, cannot unregister FCM token');
        return;
      }

      await UsersApi.unregisterFCMTokenApi(userId);
      _logger.info('FCM token unregistered successfully');
    } catch (e, stackTrace) {
      _logger.error('Error unregistering FCM token', error: e, stackTrace: stackTrace);
    }
  }
}


