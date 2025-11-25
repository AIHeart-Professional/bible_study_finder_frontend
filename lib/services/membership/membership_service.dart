import '../../models/group/bible_study_group.dart';
import '../../models/group/user_group_membership.dart';
import '../../apis/group/group_api.dart';
import '../../apis/roles/roles_api.dart';
import '../../utils/logger.dart';
import '../../utils/auth_storage.dart';
import '../../utils/permissions.dart';

class MembershipService {
  static final _logger = getLogger('MembershipService');

  static Future<String?> _getCurrentUserId() async {
    return await AuthStorage.getUserId();
  }

  static Future<bool> isMemberOfGroup(String groupId) async {
    try {
      final myGroups = await getMyGroups();
      return myGroups.any((group) => group.id == groupId);
    } catch (e, stackTrace) {
      _logger.error('Error checking membership', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<bool> joinGroup(String groupId) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }
      
      final joinSuccess = await GroupApi.joinGroupApi(groupId, userId);
      if (!joinSuccess) {
        _logger.warning('Failed to join group, not creating role');
        return false;
      }
      
      final roleSuccess = await RolesApi.createGroupRoleApi(userId, groupId, 'member');
      if (!roleSuccess) {
        _logger.warning('Failed to create member role, but user joined group');
      }
      
      if (roleSuccess) {
        Permissions.clearGroupCache(groupId);
      }
      
      return joinSuccess;
    } catch (e, stackTrace) {
      _logger.error('Error joining group', error: e, stackTrace: stackTrace);
      throw Exception('Error joining group: $e');
    }
  }

  static Future<bool> leaveGroup(String groupId) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }
      
      final leaveSuccess = await GroupApi.leaveGroupApi(groupId, userId);
      if (!leaveSuccess) {
        _logger.warning('Failed to leave group, not removing role');
        return false;
      }
      
      final roleSuccess = await RolesApi.removeGroupRoleApi(userId, groupId);
      if (!roleSuccess) {
        _logger.warning('Failed to remove group role, but user left group');
      }
      
      if (leaveSuccess) {
        Permissions.clearGroupCache(groupId);
      }
      
      return leaveSuccess;
    } catch (e, stackTrace) {
      _logger.error('Error leaving group', error: e, stackTrace: stackTrace);
      throw Exception('Error leaving group: $e');
    }
  }

  static Future<List<BibleStudyGroup>> getMyGroups() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        _logger.warning('User not logged in, returning empty groups list');
        return [];
      }

      return await GroupApi.getUserGroupsApi(userId);
    } catch (e, stackTrace) {
      _logger.error('Error fetching my groups', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching my groups: $e');
    }
  }

  static Future<List<UserGroupMembership>> getUserMemberships() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        _logger.warning('User not logged in, returning empty memberships list');
        return [];
      }
      _logger.warning('getUserMemberships API endpoint not yet implemented, returning empty list');
      return [];
    } catch (e, stackTrace) {
      _logger.error('Error fetching user memberships', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching user memberships: $e');
    }
  }
}
