import '../models/group/role.dart';
import '../models/group/group_role.dart';
import '../services/roles/roles_service.dart';
import 'logger.dart';

class Permissions {
  static final _logger = getLogger('Permissions');
  static Map<String, List<Role>> _rolesCache = {};
  static Map<String, List<GroupRole>> _userRolesCache = {};

  static Future<bool> hasPermission(
      String groupId, String permissionAction) async {
    try {
      final userRoles = await _getUserRolesForGroup(groupId);
      if (userRoles.isEmpty) {
        return false;
      }

      final allRoles = await _getAllRoles();
      final roleNames = userRoles.map((gr) => gr.role).toSet();

      for (final roleName in roleNames) {
        final role = allRoles.firstWhere(
          (r) => r.name == roleName,
          orElse: () => Role(id: '', name: '', permissions: []),
        );
        _logger.debug('Checking role $roleName with permissions: ${role.permissions}');
        if (role.permissions.contains(permissionAction)) {
          _logger.debug('Permission $permissionAction found in role $roleName');
          return true;
        }
      }

      _logger.debug('Permission $permissionAction not found in any role');
      return false;
    } catch (e, stackTrace) {
      _logger.error('Error checking permission', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  static Future<List<String>> getUserPermissions(String groupId) async {
    try {
      final userRoles = await _getUserRolesForGroup(groupId);
      _logger.debug('User roles for group $groupId: ${userRoles.length} roles found');
      if (userRoles.isEmpty) {
        _logger.warning('No roles found for user in group $groupId');
        return [];
      }

      final allRoles = await _getAllRoles();
      _logger.debug('All roles in system: ${allRoles.map((r) => r.name).toList()}');
      final roleNames = userRoles.map((gr) => gr.role).toSet();
      _logger.debug('User role names: $roleNames');
      final permissions = <String>{};

      for (final roleName in roleNames) {
        final role = allRoles.firstWhere(
          (r) => r.name == roleName,
          orElse: () => Role(id: '', name: '', permissions: []),
        );
        _logger.debug('Role $roleName has permissions: ${role.permissions}');
        permissions.addAll(role.permissions);
      }

      _logger.debug('Final user permissions: ${permissions.toList()}');
      return permissions.toList();
    } catch (e, stackTrace) {
      _logger.error('Error getting user permissions', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  static Future<List<String>> getUserRoles(String groupId) async {
    try {
      final userRoles = await _getUserRolesForGroup(groupId);
      return userRoles.map((gr) => gr.role).toList();
    } catch (e, stackTrace) {
      _logger.error('Error getting user roles', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  static void clearCache() {
    _rolesCache.clear();
    _userRolesCache.clear();
  }

  static void clearGroupCache(String groupId) {
    _userRolesCache.remove(groupId);
  }

  static Future<List<GroupRole>> _getUserRolesForGroup(String groupId) async {
    if (_userRolesCache.containsKey(groupId)) {
      return _userRolesCache[groupId]!;
    }

    final roles = await RolesService.getUserGroupRoles(groupId);
    _logger.debug('User roles for group $groupId: ${roles.map((r) => r.role).toList()}');
    _userRolesCache[groupId] = roles;
    return roles;
  }

  static Future<List<Role>> _getAllRoles() async {
    const cacheKey = 'all_roles';
    if (_rolesCache.containsKey(cacheKey)) {
      return _rolesCache[cacheKey]!;
    }

    final roles = await RolesService.getAllRoles();
    _rolesCache[cacheKey] = roles;
    return roles;
  }
}

