import 'package:flutter/material.dart';
import '../../models/group/bible_study_group.dart';
import '../../models/group/group_member.dart';
import '../../services/group/group_service.dart';
import '../../core/logging/logger.dart';

class GroupInfoTab extends StatefulWidget {
  final BibleStudyGroup group;

  const GroupInfoTab({
    super.key,
    required this.group,
  });

  @override
  State<GroupInfoTab> createState() => _GroupInfoTabState();
}

class _GroupInfoTabState extends State<GroupInfoTab> {
  final _logger = getLogger('GroupInfoTab');
  List<GroupMember> _members = [];
  bool _isLoadingMembers = false;
  bool _membersExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    _logger.debug('Loading members for group: ${widget.group.id}');
    setState(() => _isLoadingMembers = true);
    try {
      final members = await GroupService.getGroupMembers(widget.group.id);
      if (mounted) {
        setState(() {
          _members = members;
          _isLoadingMembers = false;
        });
      }
    } catch (e, stackTrace) {
      _logger.error('Error loading members', error: e, stackTrace: stackTrace);
      if (mounted) {
        setState(() => _isLoadingMembers = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context),
              _buildInfoSection(context),
              _buildMembersSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.group.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.groups,
              size: 80,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.group.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.group.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(context, Icons.location_on, 'Location', widget.group.location),
          if (widget.group.meetingDay != null || widget.group.meetingTime != null)
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Meeting Time',
              '${widget.group.meetingDay ?? ''}${widget.group.meetingDay != null ? 's' : ''}${widget.group.meetingTime != null ? ', ${widget.group.meetingTime}' : ''}',
            ),
          if (widget.group.language != null)
            _buildInfoRow(context, Icons.language, 'Language', widget.group.language!),
          if (widget.group.studyType != null)
            _buildInfoRow(context, Icons.menu_book, 'Study Type', widget.group.studyType!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() => _membersExpanded = !_membersExpanded);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Members (${_isLoadingMembers ? '...' : _members.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Icon(
                    _membersExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
          if (_membersExpanded) _buildMembersList(context),
        ],
      ),
    );
  }

  Widget _buildMembersList(BuildContext context) {
    if (_isLoadingMembers) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_members.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No members found',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: _members.map((member) => _buildMemberChip(context, member)).toList(),
      ),
    );
  }

  Widget _buildMemberChip(BuildContext context, GroupMember member) {
    return Chip(
      avatar: member.portraitUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(member.portraitUrl!),
              radius: 12,
            )
          : CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              radius: 12,
              child: Text(
                member.username.isNotEmpty ? member.username[0].toUpperCase() : '?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      label: Text(member.username),
      labelStyle: Theme.of(context).textTheme.bodySmall,
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
  }
}

