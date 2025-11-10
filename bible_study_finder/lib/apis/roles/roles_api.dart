import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/group/role.dart';
import '../../models/group/group_role.dart';
import '../../utils/app_config.dart';
import '../../utils/logger.dart';
import '../../utils/auth_storage.dart';

class RolesApi {
  static final _logger = getLogger('RolesApi');

  static Future<List<GroupRole>> getGroupRolesApi(
      String? groupId, String? userId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildGetGroupRolesUrl(groupId, userId);

    _logger.debug('Fetching group roles from: $url');

    try {
      final response = await _sendGetGroupRolesRequest(url);
      stopwatch.stop();
      _logApiCall('GET', url.toString(), response.statusCode, stopwatch);
      return _handleGetGroupRolesResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('GET', url.toString(), e);
      _logger.error('Error fetching group roles', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<List<Role>> getRolesApi() async {
    final stopwatch = Stopwatch()..start();
    final url = _buildGetRolesUrl();

    _logger.debug('Fetching roles from: $url');

    try {
      final response = await _sendGetRolesRequest(url);
      stopwatch.stop();
      _logApiCall('GET', url.toString(), response.statusCode, stopwatch);
      return _handleGetRolesResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('GET', url.toString(), e);
      _logger.error('Error fetching roles', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildGetGroupRolesUrl(String? groupId, String? userId) {
    final uri = Uri.parse('${AppConfig.getBackendBaseUrl()}/roles/get_group_roles');
    final queryParams = <String, String>{};
    if (groupId != null) {
      queryParams['groupId'] = groupId;
    }
    if (userId != null) {
      queryParams['userId'] = userId;
    }
    return uri.replace(queryParameters: queryParams);
  }

  static Uri _buildGetRolesUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/roles/get_roles');
  }

  static Future<http.Response> _sendGetGroupRolesRequest(Uri url) async {
    final headers = await AuthStorage.getAuthHeaders();
    return await http.get(url, headers: headers).timeout(AppConfig.apiTimeout);
  }

  static Future<http.Response> _sendGetRolesRequest(Uri url) async {
    final headers = await AuthStorage.getAuthHeaders();
    return await http.get(url, headers: headers).timeout(AppConfig.apiTimeout);
  }

  static List<GroupRole> _handleGetGroupRolesResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      final groupRoles = jsonData['groupRoles'] ?? [];

      _logger.debug('API response - success: $success, groupRoles count: ${groupRoles.length}');
      _logger.debug('Raw groupRoles data: $groupRoles');

      if (success) {
        final parsedRoles = (groupRoles as List<dynamic>)
            .map((item) => GroupRole.fromJson(item))
            .toList();
        _logger.debug('Parsed ${parsedRoles.length} group roles');
        return parsedRoles;
      } else {
        _logger.warning('API returned success=false');
        return [];
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      return [];
    }
  }

  static List<Role> _handleGetRolesResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      final roles = jsonData['roles'] ?? [];

      if (success) {
        return (roles as List<dynamic>)
            .map((item) => Role.fromJson(item))
            .toList();
      } else {
        _logger.warning('API returned success=false');
        return [];
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      return [];
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

