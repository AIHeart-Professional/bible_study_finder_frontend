import '../../apis/roles/roles_api.dart';
import '../../models/group/role.dart';
import '../../models/group/group_role.dart';
import '../../core/logging/logger.dart';
import '../../core/auth/auth_storage.dart';

class RolesService {
  static final _logger = getLogger('RolesService');

  static Future<List<GroupRole>> getUserGroupRoles(
      String groupId) async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        _logger.warning('No user ID found in storage');
        return [];
      }
      _logger.debug('Fetching roles for userId: $userId, groupId: $groupId');
      final roles = await RolesApi.getGroupRolesApi(groupId, userId);
      _logger.debug('Received ${roles.length} group roles from API');
      return roles;
    } catch (e, stackTrace) {
      _logger.error('Error fetching user group roles', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  static Future<List<Role>> getAllRoles() async {
    try {
      return await RolesApi.getRolesApi();
    } catch (e, stackTrace) {
      _logger.error('Error fetching all roles', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  static Future<List<dynamic>> getAllPermissions() async {
    _logger.debug('Fetching all permissions');
    try {
      final permissions = await RolesApi.getPermissionsApi();
      _logger.info('Retrieved ${permissions.length} permissions');
      return permissions;
    } catch (e, stackTrace) {
      _logger.error('Error fetching permissions', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  static Future<bool> modifyRole(
      String roleId, String? name, List<String>? permissions) async {
    _logger.debug('Modifying role: roleId=$roleId');
    try {
      final success = await RolesApi.modifyRoleApi(roleId, name, permissions);
      if (success) {
        _logger.info('Successfully modified role: $roleId');
      } else {
        _logger.warning('Failed to modify role: $roleId');
      }
      return success;
    } catch (e, stackTrace) {
      _logger.error('Error modifying role', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<String?> _getCurrentUserId() async {
    return await AuthStorage.getUserId();
  }
}

