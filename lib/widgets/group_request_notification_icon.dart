import 'package:flutter/material.dart';
import '../models/group/group_request.dart';
import '../services/group/group_service.dart';
import '../utils/auth_storage.dart';
import '../utils/logger.dart';

class GroupRequestNotificationIcon extends StatefulWidget {
  final VoidCallback? onTap;

  const GroupRequestNotificationIcon({
    super.key,
    this.onTap,
  });

  @override
  State<GroupRequestNotificationIcon> createState() =>
      _GroupRequestNotificationIconState();
}

class _GroupRequestNotificationIconState
    extends State<GroupRequestNotificationIcon> {
  final _logger = getLogger('GroupRequestNotificationIcon');
  int _pendingRequestCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  Future<void> _loadPendingRequests() async {
    _logger.debug('Loading pending group requests');
    setState(() => _isLoading = true);

    try {
      final userId = await AuthStorage.getUserId();
      if (userId == null) {
        _logger.warning('User not logged in');
        if (mounted) {
          setState(() {
            _pendingRequestCount = 0;
            _isLoading = false;
          });
        }
        return;
      }

      final allGroups = await GroupService.getGroups();
      final ownedGroups = allGroups.where((group) => group.leaderUserId == userId).toList();

      int totalPending = 0;
      for (final group in ownedGroups) {
        try {
          final requests = await GroupService.getGroupRequests(group.id);
          final pending = requests.where((r) => r.status == 'pending').length;
          totalPending += pending;
        } catch (e) {
          _logger.warning('Error loading requests for group ${group.id}: $e');
        }
      }

      _logger.info('Found $totalPending pending group requests');
      if (mounted) {
        setState(() {
          _pendingRequestCount = totalPending;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      _logger.error('Error loading pending requests',
          error: e, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _pendingRequestCount = 0;
          _isLoading = false;
        });
      }
    }
  }

  void refresh() {
    _loadPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          _showGroupRequestsDialog();
        }
      },
      child: Stack(
        children: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.notifications_outlined),
            onPressed: () {
              if (widget.onTap != null) {
                widget.onTap!();
              } else {
                _showGroupRequestsDialog();
              }
            },
            tooltip: 'Group Requests',
          ),
          if (_pendingRequestCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  _pendingRequestCount > 99 ? '99+' : '$_pendingRequestCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showGroupRequestsDialog() async {
    _logger.debug('Showing group requests dialog');
    final userId = await AuthStorage.getUserId();
    if (userId == null) {
      _logger.warning('User not logged in');
      return;
    }

    try {
      final allGroups = await GroupService.getGroups();
      final ownedGroups = allGroups.where((group) => group.leaderUserId == userId).toList();

      final Map<String, List<GroupRequest>> groupRequestsMap = {};
      for (final group in ownedGroups) {
        try {
          final requests = await GroupService.getGroupRequests(group.id);
          final pending = requests.where((r) => r.status == 'pending').toList();
          if (pending.isNotEmpty) {
            groupRequestsMap[group.id] = pending;
          }
        } catch (e) {
          _logger.warning('Error loading requests for group ${group.id}: $e');
        }
      }

      if (!mounted) return;

      if (groupRequestsMap.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No pending group requests'),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Group Requests'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: groupRequestsMap.length,
              itemBuilder: (context, index) {
                final groupId = groupRequestsMap.keys.elementAt(index);
                final group = ownedGroups.firstWhere((g) => g.id == groupId);
                final requests = groupRequestsMap[groupId]!;

                return ExpansionTile(
                  title: Text(group.name),
                  subtitle: Text('${requests.length} pending request(s)'),
                  children: requests.map((request) {
                    return ListTile(
                      title: Text(request.username ?? 'Unknown User'),
                      subtitle: Text(request.requestMessage.isEmpty
                          ? 'No message provided'
                          : request.requestMessage),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => _handleRequestAction(
                                request, groupId, true),
                            tooltip: 'Approve',
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _handleRequestAction(
                                request, groupId, false),
                            tooltip: 'Reject',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Error showing group requests dialog',
          error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading requests: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleRequestAction(
      GroupRequest request, String groupId, bool approve) async {
    _logger.debug(
        'Handling request action: approve=$approve, requestId=${request.id}');
    // TODO: Implement approve/reject API calls
    // For now, just show a message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(approve ? 'Request approved' : 'Request rejected'),
          backgroundColor: approve ? Colors.green : Colors.red,
        ),
      );
      Navigator.of(context).pop();
      _loadPendingRequests();
    }
  }
}

