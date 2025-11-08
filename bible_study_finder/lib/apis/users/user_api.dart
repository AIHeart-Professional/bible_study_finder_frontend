import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/users/user.dart';
import '../../utils/app_config.dart';
import '../../utils/logger.dart';

class UserApi {
  static final _logger = getLogger('UserApi');

  static Future<LoginResponse> loginApi(LoginRequest request) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildLoginUrl();

    _logger.debug('Logging in user: ${request.email}');

    try {
      final response = await _sendLoginRequest(url, request);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleLoginResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error logging in', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildLoginUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/users/login');
  }

  static Future<http.Response> _sendLoginRequest(
      Uri url, LoginRequest request) async {
    return await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(request.toJson()),
        )
        .timeout(AppConfig.apiTimeout);
  }

  static LoginResponse _handleLoginResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(jsonData);

      if (loginResponse.authenticated) {
        _logger.info('User successfully logged in');
      } else {
        _logger.warning('Login failed: ${loginResponse.message}');
      }

      return loginResponse;
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  static Future<CreateUserResponse> createUserApi(
      CreateUserRequest request) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildCreateUserUrl();

    _logger.debug('Creating user: ${request.email}');

    try {
      final response = await _sendCreateUserRequest(url, request);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleCreateUserResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error creating user', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildCreateUserUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/users/create_user');
  }

  static Future<http.Response> _sendCreateUserRequest(
      Uri url, CreateUserRequest request) async {
    return await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(request.toJson()),
        )
        .timeout(AppConfig.apiTimeout);
  }

  static CreateUserResponse _handleCreateUserResponse(
      http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final createResponse = CreateUserResponse.fromJson(jsonData);

      if (createResponse.created) {
        _logger.info('User successfully created');
      } else {
        _logger.warning('User creation failed: ${createResponse.message}');
      }

      return createResponse;
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  }

  static void _logApiCall(
      String method, String url, int statusCode, Stopwatch stopwatch) {
    final responseTime = stopwatch.elapsedMilliseconds / 1000.0;
    _logger.logApiCall(
      method: method,
      url: url,
      statusCode: statusCode,
      responseTime: responseTime,
    );
  }

  static void _logApiError(String method, String url, dynamic error) {
    _logger.logApiCall(
      method: method,
      url: url,
      error: error.toString(),
    );
  }
}

