import '../../models/group/chat_message.dart';
import '../../apis/group/group_api.dart';
import '../../core/logging/logger.dart';
import '../../core/auth/auth_storage.dart';

class ChatService {
  static final _logger = getLogger('ChatService');

  static Future<List<ChatMessage>> getChat(String groupId) async {
    try {
      return await GroupApi.getChatApi(groupId);
    } catch (e, stackTrace) {
      _logger.error('Error fetching chat', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching chat: $e');
    }
  }

  static Future<String> sendMessage(
      String groupId, String message) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }
      return await GroupApi.createGroupChatApi(groupId, userId, message);
    } catch (e, stackTrace) {
      _logger.error('Error sending message', error: e, stackTrace: stackTrace);
      throw Exception('Error sending message: $e');
    }
  }

  static Future<String?> _getCurrentUserId() async {
    return await AuthStorage.getUserId();
  }
}

