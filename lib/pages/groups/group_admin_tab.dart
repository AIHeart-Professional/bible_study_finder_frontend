import 'package:flutter/material.dart';
import '../../models/group/group_member.dart';
import '../../models/group/role.dart';
import '../../services/group/group_service.dart';
import '../../apis/group/group_api.dart';
import '../../apis/roles/roles_api.dart';
import '../../core/logging/logger.dart';
import '../../core/auth/auth_storage.dart';

class GroupAdminTab extends StatefulWidget {
  final String groupId;

  const GroupAdminTab({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupAdminTab> createState() => _GroupAdminTabState();
}

class _GroupAdminTabState extends State<GroupAdminTab> {
  final _logger = getLogger('GroupAdminTab');
  List<GroupMember> _members = [];
  List<Role> _availableRoles = [];
  bool _isLoading = true;
  String? _error;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _setLoading(true);
    try {
      final userId = await AuthStorage.getUserId();
      setState(() => _currentUserId = userId);

      final members = await GroupService.getGroupMembers(widget.groupId);
      final roles = await RolesApi.getRolesApi();

      if (mounted) {
        setState(() {
          _members = members;
          _availableRoles = roles;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      _handleLoadError(e, stackTrace);
    }
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
      _error = null;
    });
  }

  void _handleLoadError(dynamic e, StackTrace stackTrace) {
    _logger.error('Error loading admin data', error: e, stackTrace: stackTrace);
    if (mounted) {
      setState(() {
        _error = 'Failed to load members: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _removeMember(GroupMember member) async {
    final confirmed = await _showRemoveConfirmation(member);
    if (confirmed != true) return;

    _logger.debug('Removing member: ${member.userId}');
    try {
      final leaveSuccess = await GroupApi.leaveGroupApi(widget.groupId, member.userId);
      if (!leaveSuccess) {
        throw Exception('Failed to remove member from group');
      }

      final roleSuccess = await RolesApi.removeGroupRoleApi(member.userId, widget.groupId);
      if (!roleSuccess) {
        _logger.warning('Failed to remove role, but member was removed from group');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${member.username} has been removed from the group'),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e, stackTrace) {
      _logger.error('Error removing member', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove member: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateRole(GroupMember member, String newRole) async {
    if (member.role == newRole) return;

    _logger.debug('Updating role for ${member.userId} to $newRole');
    try {
      final success = await RolesApi.modifyGroupRoleApi(
        member.userId,
        widget.groupId,
        newRole,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${member.username}\'s role updated to $newRole'),
              backgroundColor: Colors.green,
            ),
          );
          _loadData();
        }
      } else {
        throw Exception('Failed to update role');
      }
    } catch (e, stackTrace) {
      _logger.error('Error updating role', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool?> _showRemoveConfirmation(GroupMember member) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove ${member.username} from this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_members.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No members found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _members.length,
        itemBuilder: (context, index) {
          return _buildMemberCard(_members[index]);
        },
      ),
    );
  }

  Widget _buildMemberCard(GroupMember member) {
    final isCurrentUser = member.userId == _currentUserId;
    final roleNames = _availableRoles.map((r) => r.name).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage: member.portraitUrl != null
                      ? NetworkImage(member.portraitUrl!)
                      : null,
                  child: member.portraitUrl == null
                      ? Text(
                          member.username.isNotEmpty
                              ? member.username[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            member.username,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (isCurrentUser) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'You',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ),
                if (!isCurrentUser)
                  IconButton(
                    onPressed: () => _removeMember(member),
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    tooltip: 'Remove member',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Role',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: member.role,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: roleNames.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (newRole) {
                          if (newRole != null) {
                            _updateRole(member, newRole);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Joined',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(member.joinedAt),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}

