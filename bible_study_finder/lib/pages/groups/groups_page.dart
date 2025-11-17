import 'package:flutter/material.dart';
import 'my_groups_page.dart';
import 'search_page.dart';
import 'create_group_page.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey _myGroupsPageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.index == 0 && _tabController.indexIsChanging == false) {
      // My Groups tab is selected, refresh it
      final state = _myGroupsPageKey.currentState;
      if (state != null) {
        // Call refresh method if it exists
        try {
          (state as dynamic).refresh();
        } catch (e) {
          // Method doesn't exist, ignore
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.groups),
              text: 'My Groups',
            ),
            Tab(
              icon: Icon(Icons.search),
              text: 'Find Groups',
            ),
            Tab(
              icon: Icon(Icons.add_circle),
              text: 'Create Group',
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MyGroupsPage(key: _myGroupsPageKey),
              const SearchPage(),
              const CreateGroupPage(),
            ],
          ),
        ),
      ],
    );
  }
}


