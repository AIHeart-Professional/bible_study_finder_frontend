import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/group/bible_study_group.dart';
import '../../models/group/worksheet.dart';
import '../../models/group/chat_message.dart';
import '../../models/group/group_member.dart';
import '../../models/group/group_request.dart';
import '../../models/group/role.dart';
import '../../models/group/location.dart';
import '../../core/config/app_config.dart';
import '../../core/logging/logger.dart';
import '../../core/auth/auth_storage.dart';

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

  static Future<List<ChatMessage>> getChatApi(String groupId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildGetChatUrl(groupId);

    _logger.debug('Fetching chat for group: $groupId from: $url');

    try {
      final headers = await AuthStorage.getAuthHeaders();
      final response = await http.get(url, headers: headers).timeout(AppConfig.apiTimeout);
      stopwatch.stop();
      _logApiCall('GET', url.toString(), response.statusCode, stopwatch);

      return _handleGetChatResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('GET', url.toString(), e);
      _logger.error('Error fetching chat', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildGetChatUrl(String groupId) {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/get_chat')
        .replace(queryParameters: {'groupId': groupId});
  }

  static List<ChatMessage> _handleGetChatResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true && jsonData['messages'] != null) {
        final messagesList = jsonData['messages'] as List;
        _logger.info('Successfully loaded ${messagesList.length} chat messages');
        return messagesList
            .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final message = jsonData['message'] ?? 'Failed to load chat';
        _logger.warning('API returned success=false: $message');
        return [];
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      return [];
    }
  }

  static Future<String> createGroupChatApi(
      String groupId, String userId, String message) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildCreateChatUrl();

    _logger.debug('Creating chat message for group: $groupId');

    try {
      final response = await _sendCreateChatRequest(url, groupId, userId, message);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleCreateChatResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error creating chat message', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildCreateChatUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/create_group_chat');
  }

  static Future<http.Response> _sendCreateChatRequest(
      Uri url, String groupId, String userId, String message) async {
    final headers = await AuthStorage.getAuthHeaders();
    return await http
        .post(
          url,
          headers: headers,
          body: json.encode({
            'groupId': groupId,
            'userId': userId,
            'message': message,
          }),
        )
        .timeout(AppConfig.apiTimeout);
  }

  static String _handleCreateChatResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      final message = jsonData['message'] ?? '';
      final chatId = jsonData['chatId'] ?? '';

      if (success) {
        _logger.info('Successfully created chat message: $chatId');
        return chatId;
      } else {
        _logger.warning('Failed to create chat message: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to create chat message: ${response.statusCode}');
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

  static Future<List<GroupMember>> getGroupMembersApi(String groupId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildGetGroupMembersUrl(groupId);

    _logger.debug('Fetching group members: groupId=$groupId');

    try {
      final response = await _sendGetGroupMembersRequest(url);
      stopwatch.stop();
      _logApiCall('GET', url.toString(), response.statusCode, stopwatch);
      return _handleGetGroupMembersResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('GET', url.toString(), e);
      _logger.error('Error fetching group members', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildGetGroupMembersUrl(String groupId) {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/get_users?groupId=$groupId');
  }

  static Future<http.Response> _sendGetGroupMembersRequest(Uri url) async {
    final headers = await AuthStorage.getAuthHeaders();
    return await http
        .get(url, headers: headers)
        .timeout(AppConfig.apiTimeout);
  }

  static List<GroupMember> _handleGetGroupMembersResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      if (success) {
        final membersList = jsonData['users'] as List? ?? [];
        _logger.info('Successfully loaded ${membersList.length} group members');
        return membersList
            .map((item) => GroupMember.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final message = jsonData['message'] ?? 'Failed to load group members';
        _logger.warning('API returned success=false: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to load group members: ${response.statusCode}');
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

  static Future<String> createGroupApi(
      String name,
      String description,
      String leaderUserId,
      Location location,
      String? image) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildCreateGroupUrl();

    _logger.debug('Creating group: name=$name, leaderUserId=$leaderUserId');

    try {
      final response = await _sendCreateGroupRequest(
          url, name, description, leaderUserId, location, image);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleCreateGroupResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error creating group', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildCreateGroupUrl() {
    return Uri.parse('${AppConfig.getBackendBaseUrl()}/groups/create_group');
  }

  static Future<http.Response> _sendCreateGroupRequest(Uri url, String name,
      String description, String leaderUserId, Location location,
      String? image) async {
    final headers = await AuthStorage.getAuthHeaders();
    final requestHeaders = {
      ...headers,
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'name': name,
      'description': description,
      'leaderUserId': leaderUserId,
      'location': location.toJson(),
      if (image != null) 'image': image,
    });
    return await http
        .post(url, headers: requestHeaders, body: body)
        .timeout(AppConfig.apiTimeout);
  }

  static String _handleCreateGroupResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      if (success) {
        final groupId = jsonData['groupId'] ?? '';
        _logger.info('Successfully created group: $groupId');
        return groupId;
      } else {
        final message = jsonData['message'] ?? 'Failed to create group';
        _logger.warning('API returned success=false: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to create group: ${response.statusCode}');
    }
  }

  static Future<bool> createGroupRequestApi(
      String groupId, String userId, String requestMessage) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildCreateGroupRequestUrl();

    _logger.debug(
        'Creating group request: groupId=$groupId, userId=$userId, message=$requestMessage');

    try {
      final response =
          await _sendCreateGroupRequestRequest(url, groupId, userId, requestMessage);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleCreateGroupRequestResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error creating group request',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildCreateGroupRequestUrl() {
    return Uri.parse(
        '${AppConfig.getBackendBaseUrl()}/groups/create_group_request');
  }

  static Future<http.Response> _sendCreateGroupRequestRequest(
      Uri url, String groupId, String userId, String requestMessage) async {
    final headers = await AuthStorage.getAuthHeaders();
    final requestHeaders = {
      ...headers,
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'groupId': groupId,
      'userId': userId,
      'requestMessage': requestMessage,
    });
    return await http
        .post(url, headers: requestHeaders, body: body)
        .timeout(AppConfig.apiTimeout);
  }

  static bool _handleCreateGroupRequestResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      if (success) {
        _logger.info('Successfully created group request');
        return true;
      } else {
        final message = jsonData['message'] ?? 'Failed to create group request';
        _logger.warning('API returned success=false: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to create group request: ${response.statusCode}');
    }
  }

  static Future<List<GroupRequest>> getGroupRequestsApi(String groupId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildGetGroupRequestsUrl(groupId);

    _logger.debug('Fetching group requests: groupId=$groupId');

    try {
      final response = await _sendGetGroupRequestsRequest(url);
      stopwatch.stop();
      _logApiCall('GET', url.toString(), response.statusCode, stopwatch);
      return _handleGetGroupRequestsResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('GET', url.toString(), e);
      _logger.error('Error fetching group requests',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildGetGroupRequestsUrl(String groupId) {
    return Uri.parse(
        '${AppConfig.getBackendBaseUrl()}/groups/get_group_requests?groupId=$groupId');
  }

  static Future<http.Response> _sendGetGroupRequestsRequest(Uri url) async {
    final headers = await AuthStorage.getAuthHeaders();
    return await http
        .get(url, headers: headers)
        .timeout(AppConfig.apiTimeout);
  }

  static List<GroupRequest> _handleGetGroupRequestsResponse(
      http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      if (success) {
        final requestsList = jsonData['requests'] as List? ?? [];
        _logger.info('Successfully loaded ${requestsList.length} group requests');
        return requestsList
            .map((item) =>
                GroupRequest.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final message = jsonData['message'] ?? 'Failed to load group requests';
        _logger.warning('API returned success=false: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception('Failed to load group requests: ${response.statusCode}');
    }
  }

  static void _logApiError(String method, String url, dynamic error) {
    _logger.logApiCall(
      method: method,
      url: url,
      error: error.toString(),
    );
  }

  static Future<List<Role>> getGroupRoleConfigsApi(String groupId) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildGetGroupRoleConfigsUrl(groupId);

    _logger.debug('Fetching group role configs: groupId=$groupId');

    try {
      final response = await _sendGetGroupRoleConfigsRequest(url);
      stopwatch.stop();
      _logApiCall('GET', url.toString(), response.statusCode, stopwatch);
      return _handleGetGroupRoleConfigsResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('GET', url.toString(), e);
      _logger.error('Error fetching group role configs',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Future<bool> updateGroupRoleConfigApi(
      String groupId, String roleName, List<String> permissions) async {
    final stopwatch = Stopwatch()..start();
    final url = _buildUpdateGroupRoleConfigUrl();

    _logger.debug(
        'Updating group role config: groupId=$groupId, roleName=$roleName');

    try {
      final response = await _sendUpdateGroupRoleConfigRequest(
          url, groupId, roleName, permissions);
      stopwatch.stop();
      _logApiCall('POST', url.toString(), response.statusCode, stopwatch);
      return _handleUpdateGroupRoleConfigResponse(response);
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logApiError('POST', url.toString(), e);
      _logger.error('Error updating group role config',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  static Uri _buildGetGroupRoleConfigsUrl(String groupId) {
    return Uri.parse(
        '${AppConfig.getBackendBaseUrl()}/groups/get_group_role_configs?groupId=$groupId');
  }

  static Uri _buildUpdateGroupRoleConfigUrl() {
    return Uri.parse(
        '${AppConfig.getBackendBaseUrl()}/groups/update_group_role_config');
  }

  static Future<http.Response> _sendGetGroupRoleConfigsRequest(
      Uri url) async {
    final headers = await AuthStorage.getAuthHeaders();
    return await http.get(url, headers: headers).timeout(AppConfig.apiTimeout);
  }

  static Future<http.Response> _sendUpdateGroupRoleConfigRequest(
      Uri url, String groupId, String roleName, List<String> permissions) async {
    final authHeaders = await AuthStorage.getAuthHeaders();
    final headers = {
      ...authHeaders,
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'groupId': groupId,
      'roleName': roleName,
      'permissions': permissions,
    });
    return await http
        .post(url, headers: headers, body: body)
        .timeout(AppConfig.apiTimeout);
  }

  static List<Role> _handleGetGroupRoleConfigsResponse(
      http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      if (success) {
        final rolesList = jsonData['groupRoles'] as List? ?? [];
        _logger.info(
            'Successfully loaded ${rolesList.length} group role configs');
        return rolesList
            .map((item) => Role.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        final message =
            jsonData['message'] ?? 'Failed to load group role configs';
        _logger.warning('API returned success=false: $message');
        throw Exception(message);
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      throw Exception(
          'Failed to load group role configs: HTTP ${response.statusCode}');
    }
  }

  static bool _handleUpdateGroupRoleConfigResponse(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final success = jsonData['success'] ?? false;
      if (success) {
        _logger.info('Successfully updated group role config');
        return true;
      } else {
        final message =
            jsonData['message'] ?? 'Failed to update group role config';
        _logger.warning('API returned success=false: $message');
        return false;
      }
    } else {
      _logger.error('HTTP error: ${response.statusCode}');
      return false;
    }
  }
}

