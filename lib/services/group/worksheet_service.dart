import '../../models/group/worksheet.dart';
import '../../apis/group/group_api.dart';
import '../../core/logging/logger.dart';

class WorksheetService {
  static final _logger = getLogger('WorksheetService');

  static Future<List<Worksheet>> getWorksheets(String groupId) async {
    try {
      return await GroupApi.getWorksheetsApi(groupId);
    } catch (e, stackTrace) {
      _logger.error('Error fetching worksheets', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching worksheets: $e');
    }
  }
}


