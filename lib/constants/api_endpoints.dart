/// Centralized API endpoint constants for the Bible Study Finder app.
/// 
/// All API endpoints should be defined here for:
/// - Easy maintenance
/// - Consistent endpoint usage
/// - Quick updates when backend changes
/// - Better organization
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  // Base URLs are in AppConfig, these are just the paths

  // Group endpoints
  static const String getGroups = '/groups/get_groups';
  static const String getGroupById = '/groups/get_group_by_id';
  static const String createGroup = '/groups/create_group';
  static const String updateGroup = '/groups/update_group';
  static const String deleteGroup = '/groups/delete_group';
  static const String searchGroups = '/groups/search_groups';

  // Group Request endpoints
  static const String createGroupRequest = '/groups/create_group_request';
  static const String getGroupRequests = '/groups/get_group_requests';
  static const String approveGroupRequest = '/groups/approve_group_request';
  static const String rejectGroupRequest = '/groups/reject_group_request';

  // Membership endpoints
  static const String joinGroup = '/membership/join_group';
  static const String leaveGroup = '/membership/leave_group';
  static const String getMyGroups = '/membership/get_my_groups';
  static const String getUserMemberships = '/membership/get_user_memberships';

  // Role endpoints
  static const String getRoles = '/roles/get_roles';
  static const String createRole = '/roles/create_role';
  static const String updateRole = '/roles/update_role';
  static const String deleteRole = '/roles/delete_role';
  static const String getGroupRoles = '/roles/get_group_roles';
  static const String createGroupRole = '/roles/create_group_role';
  static const String removeGroupRole = '/roles/remove_group_role';

  // User endpoints
  static const String createUser = '/users/create_user';
  static const String loginUser = '/users/login_user';
  static const String getUser = '/users/get_user';
  static const String updateUser = '/users/update_user';
  static const String deleteUser = '/users/delete_user';
  static const String getUserById = '/users/get_user_by_id';

  // Church endpoints
  static const String searchChurches = '/churches/search';
  static const String getChurchById = '/churches/get_church_by_id';

  // Bible endpoints (external API)
  static const String getBibles = '/bibles';
  static const String getBooks = '/bibles/{bibleId}/books';
  static const String getChapters = '/bibles/{bibleId}/books/{bookId}/chapters';
  static const String getVerses = '/bibles/{bibleId}/chapters/{chapterId}/verses';
  static const String getVerse = '/bibles/{bibleId}/verses/{verseId}';
  static const String searchVerses = '/bibles/{bibleId}/search';

  // Worksheet endpoints
  static const String getWorksheets = '/worksheets/get_worksheets';
  static const String createWorksheet = '/worksheets/create_worksheet';
  static const String updateWorksheet = '/worksheets/update_worksheet';
  static const String deleteWorksheet = '/worksheets/delete_worksheet';

  // Chat endpoints
  static const String getChatMessages = '/chats/get_messages';
  static const String sendChatMessage = '/chats/send_message';
  static const String deleteChatMessage = '/chats/delete_message';

  // Notification endpoints
  static const String registerFcmToken = '/notifications/register_token';
  static const String unregisterFcmToken = '/notifications/unregister_token';

  // Helper method to replace path parameters
  static String replacePath(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}

