import 'package:flutter/material.dart';
import '../../models/group/bible_study_group.dart';
import '../../models/group/worksheet.dart';
import '../../models/group/chat_message.dart';
import '../../services/group/group_service.dart';
import '../../services/group/worksheet_service.dart';
import '../../services/group/chat_service.dart';
import '../../core/logging/logger.dart';
import '../../core/permissions/permissions.dart';
import '../../widgets/background_image.dart';
import 'group_info_tab.dart';
import 'group_chats_tab.dart';
import 'group_resources_tab.dart';
import 'group_admin_tab.dart';

class GroupDetailPage extends StatefulWidget {
  final String groupId;

  const GroupDetailPage({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final _logger = getLogger('GroupDetailPage');
  final PageController _pageController = PageController();
  int _currentTabIndex = 0;
  BibleStudyGroup? _group;
  List<Worksheet> _worksheets = [];
  List<ChatMessage> _chatMessages = [];
  List<String> _userPermissions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadGroupData() async {
    _setLoading(true);
    try {
      final group = await GroupService.getGroup(widget.groupId);
      final worksheets = await WorksheetService.getWorksheets(widget.groupId);
      final permissions = await Permissions.getUserPermissions(widget.groupId);
      _updateGroupData(group, worksheets, permissions);
    } catch (e, stackTrace) {
      _handleLoadError(e, stackTrace);
    }
  }

  Future<void> _loadChatMessages() async {
    try {
      final messages = await ChatService.getChat(widget.groupId);
      if (mounted) {
        setState(() {
          _chatMessages = _sortMessagesByDate(messages);
        });
      }
    } catch (e, stackTrace) {
      _logger.error('Error loading chat messages', error: e, stackTrace: stackTrace);
    }
  }

  List<ChatMessage> _sortMessagesByDate(List<ChatMessage> messages) {
    final sorted = List<ChatMessage>.from(messages);
    sorted.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return sorted;
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
      _error = null;
    });
  }

  void _updateGroupData(BibleStudyGroup group, List<Worksheet> worksheets,
      List<String> permissions) {
    if (mounted) {
      setState(() {
        _group = group;
        _worksheets = worksheets;
        _userPermissions = permissions;
        _isLoading = false;
      });
    }
  }

  void _handleLoadError(dynamic e, StackTrace stackTrace) {
    _logger.error('Error loading group data', error: e, stackTrace: stackTrace);
    if (mounted) {
      setState(() {
        _error = 'Failed to load group: $e';
        _isLoading = false;
      });
    }
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    if (index == 1 && _chatMessages.isEmpty) {
      _loadChatMessages();
    }
  }

  bool _isAdmin() {
    return _userPermissions.contains('manage_members') ||
        _userPermissions.contains('admin') ||
        _userPermissions.contains('upload_resources');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }
    if (_error != null) {
      return _buildErrorState();
    }
    if (_group == null) {
      return _buildEmptyState();
    }
    return _buildContent();
  }

  Widget _buildLoadingState() {
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Loading...'),
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
        body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading group details...'),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
        body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                'Error Loading Group',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _error ?? 'Unknown error',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadGroupData,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Group Not Found'),
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
        body: const Center(
        child: Text('Group not found'),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_group?.name ?? ''),
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
           body: PageView(
             controller: _pageController,
             onPageChanged: _onPageChanged,
             children: _buildTabPages(),
           ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: _buildTabItems(),
      ),
      ),
    );
  }

  List<Widget> _buildTabPages() {
    final pages = [
      GroupInfoTab(group: _group!),
      GroupChatsTab(
        groupId: widget.groupId,
        messages: _chatMessages,
        onRefresh: _loadChatMessages,
      ),
      GroupResourcesTab(
        worksheets: _worksheets,
        groupId: widget.groupId,
        userPermissions: _userPermissions,
      ),
    ];

    if (_isAdmin()) {
      pages.add(GroupAdminTab(groupId: widget.groupId));
    }

    return pages;
  }

  List<BottomNavigationBarItem> _buildTabItems() {
    final items = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.info_outline),
        activeIcon: Icon(Icons.info),
        label: 'Info',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline),
        activeIcon: Icon(Icons.chat_bubble),
        label: 'Chats',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.folder_outlined),
        activeIcon: Icon(Icons.folder),
        label: 'Resources',
      ),
    ];

    if (_isAdmin()) {
      return [
        ...items,
        const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          activeIcon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      ];
    }

    return items;
  }
}
