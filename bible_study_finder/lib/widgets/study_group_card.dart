import 'package:flutter/material.dart';
import '../models/bible_study_group.dart';

class StudyGroupCard extends StatelessWidget {
  final BibleStudyGroup group;

  const StudyGroupCard({
    super.key,
    required this.group,
  });

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
                  group.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  group.description,
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
                    if (group.isOnline)
                      _FeatureChip(
                        icon: Icons.computer,
                        label: 'Online',
                        color: Colors.blue,
                      ),
                    if (group.isInPerson)
                      _FeatureChip(
                        icon: Icons.location_on,
                        label: 'In-Person',
                        color: Colors.green,
                      ),
                    if (group.isChildcareAvailable)
                      _FeatureChip(
                        icon: Icons.child_care,
                        label: 'Childcare',
                        color: Colors.pink,
                      ),
                    if (group.isBeginnersWelcome)
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
                      text: group.location,
                    ),
                    const SizedBox(height: 8),
                    _DetailRow(
                      icon: Icons.calendar_today,
                      text: '${group.meetingDay}s, ${group.meetingTime}',
                    ),
                    const SizedBox(height: 8),
                    _DetailRow(
                      icon: Icons.people,
                      text: '${group.groupSize} members • ${group.ageGroup}',
                    ),
                    const SizedBox(height: 8),
                    _DetailRow(
                      icon: Icons.language,
                      text: '${group.language} • ${group.studyType}',
                    ),
                    if (group.distance > 0) ...[
                      const SizedBox(height: 8),
                      _DetailRow(
                        icon: Icons.directions_car,
                        text: '${group.distance} miles away',
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
                              content: Text('Joining ${group.name}...'),
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
                  group.name,
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
                  group.description,
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
                _DetailRow(icon: Icons.location_on, text: group.location),
                const SizedBox(height: 8),
                _DetailRow(icon: Icons.calendar_today, text: '${group.meetingDay}s'),
                const SizedBox(height: 8),
                _DetailRow(icon: Icons.access_time, text: group.meetingTime),
                const SizedBox(height: 8),
                _DetailRow(icon: Icons.book, text: group.studyType),
                const SizedBox(height: 8),
                _DetailRow(icon: Icons.people, text: '${group.groupSize} members'),
                const SizedBox(height: 8),
                _DetailRow(icon: Icons.group, text: group.ageGroup),
                const SizedBox(height: 8),
                _DetailRow(icon: Icons.language, text: group.language),
                if (group.distance > 0) ...[
                  const SizedBox(height: 8),
                  _DetailRow(icon: Icons.directions_car, text: '${group.distance} miles away'),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Joining ${group.name}...'),
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

