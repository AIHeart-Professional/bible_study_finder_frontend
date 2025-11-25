import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/app_config.dart';
import '../../utils/logger.dart';
import '../../utils/auth_storage.dart';

class UsersApi {
  static final _logger = getLogger('UsersApi');

  static Future<bool> registerFCMTokenApi(String userId, String fcmToken) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildRegisterFCMTokenUrl();

    _logger.debug('Registering FCM token for userId: $userId');

    try {
      final response = await _sendRegisterFCMTokenRequest(url, userId, fcmToken);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleRegisterFCMTokenResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error registering FCM token', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<bool> unregisterFCMTokenApi(String userId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildUnregisterFCMTokenUrl();

    _logger.debug('Unregistering FCM token for userId: $userId');

    try {
      final response = await _sendUnregisterFCMTokenRequest(url, userId);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleUnregisterFCMTokenResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error unregistering FCM token', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  static Uri _buildRegisterFCMTokenUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/users/register_fcm_token');
  }

  static Uri _buildUnregisterFCMTokenUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/users/unregister_fcm_token');
  }

  static Future<http.Response> _sendRegisterFCMTokenRequest(
      Uri url, String userId, String fcmToken) async {
    final authHeaders = await AuthStorage.getAuthHeaders();
    final headers = {
      ...authHeaders,
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'userId': userId,
      'fcmToken': fcmToken,
    });
    return await http
        .post(url, headers: headers, body: body)
        .timeout(AppConfig.apiTimeout);
  }

  static Future<http.Response> _sendUnregisterFCMTokenRequest(
      Uri url, String userId) async {
    final authHeaders = await AuthStorage.getAuthHeaders();
    final headers = {
      ...authHeaders,
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'userId': userId,
    });
    return await http
        .post(url, headers: headers, body: body)
        .timeout(AppConfig.apiTimeout);
  }

  static bool _handleRegisterFCMTokenResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      if (success) {
        _logger.debug('Successfully registered FCM token');
        return true;
      } else {
        final message = jsonData['message'] ?? 'Failed to register FCM token';
        _logger.warning('API returned success=false: $message');
        return false;
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      return false;
    }
  }

  static bool _handleUnregisterFCMTokenResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      if (success) {
        _logger.debug('Successfully unregistered FCM token');
        return true;
      } else {
        final message = jsonData['message'] ?? 'Failed to unregister FCM token';
        _logger.warning('API returned success=false: $message');
        return false;
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      return false;
    }
  }

  static void _logApiCall(String method, String url, int statusCode, Stopwatch stopwatch) {
    final responseTime = stopwatch.elapsedMilliseconds / 1000.0;
    _logger.logApiCall(
      method: method,
      url: url,
      statusCode: statusCode,
      responseTime: responseTime,
    );
  }

  static void _logApiError(String method, String url, dynamic error) {
    _logger.error('API call failed: $method $url', error: error);
  }
}


