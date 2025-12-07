import 'package:flutter/material.dart';
import '../../models/group/role.dart';
import '../../services/group/group_service.dart';
import '../../services/roles/roles_service.dart';
import '../../core/logging/logger.dart';

class ManageRolesPage extends StatefulWidget {
  final String groupId;
  
  const ManageRolesPage({
    super.key,
    required this.groupId,
  });

  @override
  State<ManageRolesPage> createState() => _ManageRolesPageState();
}

class _ManageRolesPageState extends State<ManageRolesPage> {
  final _logger = getLogger('ManageRolesPage');
  List<Role> _roles = [];
  List<dynamic> _permissions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _setLoading(true);
    try {
      final roles = await GroupService.getGroupRoleConfigs(widget.groupId);
      final permissions = await RolesService.getAllPermissions();

      if (mounted) {
        setState(() {
          _roles = roles;
          _permissions = permissions;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
    }
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
      _error = null;
    });
  }

  void _handleError(dynamic e, StackTrace stackTrace) {
    _logger.error('Error loading roles data', error: e, stackTrace: stackTrace);
    if (mounted) {
      setState(() {
        _error = 'Failed to load roles: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _modifyRole(Role role) async {
    final result = await _showModifyRoleDialog(role);
    if (result == true) {
      _loadData();
    }
  }

  Future<bool?> _showModifyRoleDialog(Role role) {
    final nameController = TextEditingController(text: role.name);
    final selectedPermissions = List<String>.from(role.permissions);

    return showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Modify ${role.name} Role'),
            content: _buildModifyRoleContent(
              nameController,
              selectedPermissions,
              setDialogState,
            ),
            actions: [
              _buildCancelButton(),
              _buildSaveButton(role, nameController, selectedPermissions),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModifyRoleContent(
    TextEditingController nameController,
    List<String> selectedPermissions,
    StateSetter setDialogState,
  ) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoleNameField(nameController),
            const SizedBox(height: 16),
            _buildPermissionsLabel(),
            const SizedBox(height: 8),
            _buildPermissionsList(selectedPermissions, setDialogState),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleNameField(TextEditingController nameController) {
    return TextField(
      controller: nameController,
      decoration: const InputDecoration(
        labelText: 'Role Name',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPermissionsLabel() {
    return Text(
      'Permissions',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildPermissionsList(
    List<String> selectedPermissions,
    StateSetter setDialogState,
  ) {
    return Column(
      children: _permissions.map((permission) {
        final action = permission['action'] ?? '';
        final description = permission['description'] ?? '';
        final isSelected = selectedPermissions.contains(action);

        return CheckboxListTile(
          title: Text(action),
          subtitle: Text(description),
          value: isSelected,
          onChanged: (value) {
            setDialogState(() {
              _togglePermission(selectedPermissions, action, value);
            });
          },
        );
      }).toList(),
    );
  }

  void _togglePermission(
    List<String> selectedPermissions,
    String action,
    bool? value,
  ) {
    if (value == true) {
      selectedPermissions.add(action);
    } else {
      selectedPermissions.remove(action);
    }
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: const Text('Cancel'),
    );
  }

  Widget _buildSaveButton(
    Role role,
    TextEditingController nameController,
    List<String> selectedPermissions,
  ) {
    return ElevatedButton(
      onPressed: () => _saveRoleChanges(role, nameController, selectedPermissions),
      child: const Text('Save'),
    );
  }

  Future<void> _saveRoleChanges(
    Role role,
    TextEditingController nameController,
    List<String> selectedPermissions,
  ) async {
    _logger.debug('Saving role changes for: ${role.id}');
    try {
      final success = await GroupService.updateGroupRoleConfig(
        widget.groupId,
        role.name,
        selectedPermissions,
      );

      if (success) {
        if (mounted) {
          _showSuccessMessage();
          Navigator.of(context).pop(true);
        }
      } else {
        throw Exception('Failed to modify role');
      }
    } catch (e, stackTrace) {
      _handleSaveError(e, stackTrace);
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Role updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleSaveError(dynamic e, StackTrace stackTrace) {
    _logger.error('Error saving role changes', error: e, stackTrace: stackTrace);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update role: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Roles'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_roles.isEmpty) {
      return _buildEmptyState();
    }

    return _buildRolesList();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState() {
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.admin_panel_settings_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No roles found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildRolesList() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          return _buildRoleCard(_roles[index]);
        },
      ),
    );
  }

  Widget _buildRoleCard(Role role) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _modifyRole(role),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoleHeader(role),
              const SizedBox(height: 12),
              _buildRolePermissions(role),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleHeader(Role role) {
    return Row(
      children: [
        Icon(
          Icons.admin_panel_settings,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            role.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  Widget _buildRolePermissions(Role role) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: role.permissions.map((permission) {
        return Chip(
          label: Text(
            permission,
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        );
      }).toList(),
    );
  }
}
