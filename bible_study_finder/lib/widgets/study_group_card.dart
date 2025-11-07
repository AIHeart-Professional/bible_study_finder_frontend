import 'package:flutter/material.dart';
import '../models/group/bible_study_group.dart';
import '../services/membership_service.dart';

class StudyGroupCard extends StatefulWidget {
  final BibleStudyGroup group;
  final VoidCallback? onMembershipChanged;

  const StudyGroupCard({
    super.key,
    required this.group,
    this.onMembershipChanged,
  });

  @override
  State<StudyGroupCard> createState() => _StudyGroupCardState();
}

class _StudyGroupCardState extends State<StudyGroupCard> {
  bool _isMember = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkMembership();
  }

  Future<void> _checkMembership() async {
    try {
      final isMember = await MembershipService.isMemberOfGroup(widget.group.id);
      if (mounted) {
        setState(() {
          _isMember = isMember;
        });
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _joinGroup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await MembershipService.joinGroup(widget.group.id);
      if (success) {
        setState(() {
          _isMember = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully joined ${widget.group.name}!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        widget.onMembershipChanged?.call();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are already a member of this group'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error joining group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Image
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.groups,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Name
                Text(
                  widget.group.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  widget.group.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Feature Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (widget.group.isOnline)
                      _FeatureChip(
                        icon: Icons.computer,
                        label: 'Online',
                        color: Colors.blue,
                      ),
                    if (widget.group.isInPerson)
                      _FeatureChip(
                        icon: Icons.location_on,
                        label: 'In-Person',
                        color: Colors.green,
                      ),
                    if (widget.group.isChildcareAvailable)
                      _FeatureChip(
                        icon: Icons.child_care,
                        label: 'Childcare',
                        color: Colors.pink,
                      ),
                    if (widget.group.isBeginnersWelcome)
                      _FeatureChip(
                        icon: Icons.star,
                        label: 'Beginners Welcome',
                        color: Colors.orange,
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Details
                Column(
                  children: [
                    _DetailRow(
                      icon: Icons.location_on,
                      text: widget.group.location,
                    ),
                    const SizedBox(height: 8),
                    if (widget.group.meetingDay != null || widget.group.meetingTime != null)
                      _DetailRow(
                        icon: Icons.calendar_today,
                        text: '${widget.group.meetingDay ?? 'TBD'}${widget.group.meetingDay != null ? 's' : ''}${widget.group.meetingTime != null ? ', ${widget.group.meetingTime}' : ''}',
                      ),
                    if (widget.group.meetingDay != null || widget.group.meetingTime != null)
                      const SizedBox(height: 8),
                    if (widget.group.groupSize != null || widget.group.ageGroup != null)
                      _DetailRow(
                        icon: Icons.people,
                        text: '${widget.group.groupSize ?? 'N/A'} members${widget.group.ageGroup != null ? ' • ${widget.group.ageGroup}' : ''}',
                      ),
                    if (widget.group.groupSize != null || widget.group.ageGroup != null)
                      const SizedBox(height: 8),
                    if (widget.group.language != null || widget.group.studyType != null)
                      _DetailRow(
                        icon: Icons.language,
                        text: '${widget.group.language ?? 'N/A'}${widget.group.studyType != null ? ' • ${widget.group.studyType}' : ''}',
                      ),
                    if (widget.group.distance > 0) ...[
                      const SizedBox(height: 8),
                      _DetailRow(
                        icon: Icons.directions_car,
                        text: '${widget.group.distance} miles away',
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Joining ${widget.group.name}...'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Join Group'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _showGroupDetails(context);
                        },
                        child: const Text('Learn More'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGroupDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.group.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'About This Group',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.group.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Group Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _DetailRow(icon: Icons.location_on, text: widget.group.location),
                if (widget.group.meetingDay != null) ...[
                  const SizedBox(height: 8),
                  _DetailRow(icon: Icons.calendar_today, text: '${widget.group.meetingDay}s'),
                ],
                if (widget.group.meetingTime != null) ...[
                  const SizedBox(height: 8),
                  _DetailRow(icon: Icons.access_time, text: widget.group.meetingTime!),
                ],
                if (widget.group.studyType != null) ...[
                  const SizedBox(height: 8),
                  _DetailRow(icon: Icons.book, text: widget.group.studyType!),
                ],
                if (widget.group.groupSize != null) ...[
                  const SizedBox(height: 8),
                  _DetailRow(icon: Icons.people, text: '${widget.group.groupSize} members'),
                ],
                if (widget.group.ageGroup != null) ...[
                  const SizedBox(height: 8),
                  _DetailRow(icon: Icons.group, text: widget.group.ageGroup!),
                ],
                if (widget.group.language != null) ...[
                  const SizedBox(height: 8),
                  _DetailRow(icon: Icons.language, text: widget.group.language!),
                ],
                if (widget.group.distance > 0) ...[
                  const SizedBox(height: 8),
                  _DetailRow(icon: Icons.directions_car, text: '${widget.group.distance} miles away'),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Joining ${widget.group.name}...'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.group_add),
                    label: const Text('Join This Group'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

