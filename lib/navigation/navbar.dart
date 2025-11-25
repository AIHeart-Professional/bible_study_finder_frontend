import 'package:flutter/material.dart';
import 'app_router.dart';
import '../utils/platform_helper.dart';
import '../pages/auth/auth_page.dart';
import '../utils/auth_storage.dart';
import '../widgets/group_request_notification_icon.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  late PageController _pageController;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkAuthStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await AuthStorage.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shouldUseWebLayout = PlatformHelper.shouldUseWebLayout(context);

    if (shouldUseWebLayout) {
      return _buildWebLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildWebLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onBottomNavTapped,
            labelType: NavigationRailLabelType.all,
            backgroundColor: Theme.of(context).colorScheme.surface,
            destinations: List.generate(
              AppRouter.pages.length,
              (index) => NavigationRailDestination(
                icon: Icon(AppRouter.getIcon(index)),
                selectedIcon: Icon(AppRouter.getActiveIcon(index)),
                label: Text(AppRouter.getLabel(index)),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppRouter.getTitle(_currentIndex),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppRouter.getDescription(_currentIndex),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                scrolledUnderElevation: 4,
                actions: [
                  if (_isLoggedIn) const GroupRequestNotificationIcon(),
                  if (_currentIndex == 1 || _currentIndex == 2)
                    IconButton(
                      onPressed: () => _showFilterDialog(context),
                      icon: const Icon(Icons.filter_list),
                      tooltip: 'Quick Filters',
                    ),
                  IconButton(
                    onPressed: _isLoggedIn
                        ? () => _handleLogout(context)
                        : () => _navigateToAuth(context),
                    icon: Icon(_isLoggedIn ? Icons.logout : Icons.login),
                    tooltip: _isLoggedIn ? 'Logout' : 'Login / Create Account',
                  ),
                ],
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: AppRouter.pages,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppRouter.getTitle(_currentIndex),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppRouter.getDescription(_currentIndex),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.6),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 4,
        actions: [
          if (_isLoggedIn) const GroupRequestNotificationIcon(),
          IconButton(
            onPressed: _isLoggedIn
                ? () => _handleLogout(context)
                : () => _navigateToAuth(context),
            icon: Icon(_isLoggedIn ? Icons.logout : Icons.login),
            tooltip: _isLoggedIn ? 'Logout' : 'Login / Create Account',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: AppRouter.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        onTap: _onBottomNavTapped,
        items: List.generate(
          AppRouter.pages.length,
          (index) => AppRouter.getBottomNavItem(index),
        ),
      ),
      floatingActionButton: (_currentIndex == 1 || _currentIndex == 2)
          ? FloatingActionButton(
              onPressed: () => _showFilterBottomSheet(context),
              child: const Icon(Icons.filter_list),
            )
          : null,
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Filters'),
        content: Text(
          _currentIndex == 1
              ? 'Filter Bible study groups by preferences'
              : 'Filter churches by denomination and services',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Filters',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              _currentIndex == 1
                  ? 'Filter Bible study groups by preferences'
                  : 'Filter churches by denomination and services',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAuth(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AuthPage(),
      ),
    );
    _checkAuthStatus();
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await _showLogoutConfirmation(context);
    if (confirmed == true) {
      await AuthStorage.clearAuth();
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully logged out'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<bool?> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
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
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
