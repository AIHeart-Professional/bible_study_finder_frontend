import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/group/bible_study_group.dart';
import '../../models/group/worksheet.dart';
import '../../utils/app_config.dart';
import '../../utils/logger.dart';
import '../../utils/auth_storage.dart';

class GroupApi {
  static final _logger = getLogger('GroupApi');

  static Future<List<BibleStudyGroup>> getGroupsApi() async {
    final stopwatch = Stopwatch()..start();
    final url = Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/get_groups');

    _logger.debug('Fetching groups from: $url');

    final response = await http
        .get(
          url,
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(AppConfig.apiTimeout);

    stopwatch.stop();
    final responseTime = stopwatch.elapsedMilliseconds / 1000.0;

    _logger.logApiCall(
      method: 'GET',
      url: url.toString(),
      statusCode: response.statusCode,
      responseTime: responseTime,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true && jsonData['groups'] != null) {
        final groupsList = jsonData['groups'] as List;
        _logger.info('Successfully loaded ${groupsList.length} groups');
        return groupsList
            .map((item) =>
                BibleStudyGroup.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final message = jsonData['message'] ?? 'Failed to load groups';
        _logger.warning('API returned success=false: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to load groups: ${response.statusCode}');
    }
  }

  static Future<List<BibleStudyGroup>> getUserGroupsApi(String userId) async {
    final stopwatch = Stopwatch()..start();
    final url = Uri.parse(
            '${AppConfig.getBackendBaseUrl()}/groups/get_user_groups')
        .replace(queryParameters: {'userId': userId});

    _logger.debug('Fetching user groups from: $url');

    final headers = await AuthStorage.getAuthHeaders();
    final response = await http
        .get(
          url,
          headers: headers,
        )
        .timeout(AppConfig.apiTimeout);

    stopwatch.stop();
    final responseTime = stopwatch.elapsedMilliseconds / 1000.0;

    _logger.logApiCall(
      method: 'GET',
      url: url.toString(),
      statusCode: response.statusCode,
      responseTime: responseTime,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true && jsonData['groups'] != null) {
        final groupsList = jsonData['groups'] as List;
        _logger.info('Successfully loaded ${groupsList.length} user groups');
        return groupsList
            .map((item) =>
                BibleStudyGroup.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final message = jsonData['message'] ?? 'Failed to load user groups';
        _logger.warning('API returned success=false: $message');
        return [];
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      return [];
    }
  }

  static Future<BibleStudyGroup> getGroupApi(String groupId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildGetGroupUrl(groupId);

    _logger.debug('Fetching group: $groupId from: $url');

    try {
      final headers = await AuthStorage.getAuthHeaders();
      final response = await http.get(url, headers: headers).timeout(AppConfig.apiTimeout);
      stopwatch.stop();
      _logApiCall('GET', url.toString(), response.statusCode, stopwatch);

      return _handleGetGroupResponse(response, groupId);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('GET', url.toString(), e);
      _logger.error('Error fetching group', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildGetGroupUrl(String groupId) {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/get_group')
        .replace(queryParameters: {'groupId': groupId});
  }

  static BibleStudyGroup _handleGetGroupResponse(
      http.Response response, String groupId) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true && jsonData['group'] != null) {
        _logger.info('Successfully loaded group: $groupId');
        return BibleStudyGroup.fromJson(jsonData['group']);
      } else {
        final message = jsonData['message'] ?? 'Failed to load group';
        _logger.warning('API returned success=false: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to load group: ${response.statusCode}');
    }
  }

  static Future<List<Worksheet>> getWorksheetsApi(String groupId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildGetWorksheetsUrl(groupId);

    _logger.debug('Fetching worksheets for group: $groupId from: $url');

    try {
      final headers = await AuthStorage.getAuthHeaders();
      final response = await http.get(url, headers: headers).timeout(AppConfig.apiTimeout);
      stopwatch.stop();
      _logApiCall('GET', url.toString(), response.statusCode, stopwatch);

      return _handleGetWorksheetsResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('GET', url.toString(), e);
      _logger.error('Error fetching worksheets', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildGetWorksheetsUrl(String groupId) {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/get_worksheets')
        .replace(queryParameters: {'groupId': groupId});
  }

  static List<Worksheet> _handleGetWorksheetsResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true && jsonData['worksheets'] != null) {
        final worksheetsList = jsonData['worksheets'] as List;
        _logger.info('Successfully loaded ${worksheetsList.length} worksheets');
        return worksheetsList
            .map((item) => Worksheet.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final message = jsonData['message'] ?? 'Failed to load worksheets';
        _logger.warning('API returned success=false: $message');
        return [];
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      return [];
    }
  }

  static Future<bool> joinGroupApi(String groupId, String userId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildJoinGroupUrl();

    _logger.debug('Joining group: $groupId for user: $userId');

    try {
      final response = await _sendJoinRequest(url, groupId, userId);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleJoinResponse(response, groupId);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error joining group', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildJoinGroupUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/join_group');
  }

  static Future<http.Response> _sendJoinRequest(
      Uri url, String groupId, String userId) async {
    final headers = await AuthStorage.getAuthHeaders();
    return await http
        .post(
          url,
          headers: headers,
          body: json.encode({
            'groupId': groupId,
            'userId': userId,
          }),
        )
        .timeout(AppConfig.apiTimeout);
  }

  static bool _handleJoinResponse(http.Response response, String groupId) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      final message = jsonData['message'] ?? '';

      if (success) {
        _logger.info('Successfully joined group: $groupId');
        return true;
      } else {
        _logger.warning('Failed to join group: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to join group: ${response.statusCode}');
    }
  }

  static Future<bool> leaveGroupApi(String groupId, String userId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildLeaveGroupUrl();

    _logger.debug('Leaving group: $groupId for user: $userId');

    try {
      final response = await _sendLeaveRequest(url, groupId, userId);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleLeaveResponse(response, groupId);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error leaving group', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildLeaveGroupUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/leave_group');
  }

  static Future<http.Response> _sendLeaveRequest(
      Uri url, String groupId, String userId) async {
    final headers = await AuthStorage.getAuthHeaders();
    return await http
        .post(
          url,
          headers: headers,
          body: json.encode({
            'groupId': groupId,
            'userId': userId,
          }),
        )
        .timeout(AppConfig.apiTimeout);
  }

  static bool _handleLeaveResponse(http.Response response, String groupId) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      final message = jsonData['message'] ?? '';

      if (success) {
        _logger.info('Successfully left group: $groupId');
        return true;
      } else {
        _logger.warning('Failed to leave group: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to leave group: ${response.statusCode}');
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

