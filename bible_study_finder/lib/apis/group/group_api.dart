import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/group/bible_study_group.dart';
import '../../utils/app_config.dart';
import '../../utils/logger.dart';

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
}

