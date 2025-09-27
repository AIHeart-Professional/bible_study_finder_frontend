import 'package:flutter/material.dart';
import '../models/app_feature.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const List<TeamMember> teamMembers = [
    TeamMember(
      name: 'Sarah Johnson',
      role: 'Lead Developer',
      bio: 'Passionate about creating technology that brings people closer to God\'s Word.',
      image: '👩‍💻',
    ),
    TeamMember(
      name: 'Michael Chen',
      role: 'UX Designer',
      bio: 'Dedicated to making Bible study accessible and engaging for everyone.',
      image: '👨‍🎨',
    ),
    TeamMember(
      name: 'Pastor David Williams',
      role: 'Content Advisor',
      bio: 'Ensuring theological accuracy and spiritual depth in our study materials.',
      image: '👨‍🏫',
    ),
  ];

  static const List<AppFeature> features = [
    AppFeature(
      title: 'Comprehensive Study Tools',
      description: 'Access commentaries, concordances, and cross-references to deepen your understanding.',
      icon: '🛠️',
    ),
    AppFeature(
      title: 'Community Engagement',
      description: 'Join study groups, share insights, and learn from fellow believers worldwide.',
      icon: '🤝',
    ),
    AppFeature(
      title: 'Progress Tracking',
      description: 'Monitor your reading progress and maintain consistent study habits.',
      icon: '📈',
    ),
    AppFeature(
      title: 'Multiple Translations',
      description: 'Compare verses across different Bible translations for deeper insight.',
      icon: '📚',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Section
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.church,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  'About Our Mission',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'re dedicated to making Bible study more accessible, engaging, and meaningful for believers around the world.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Mission Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Mission',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Our Bible Study application was born from a simple belief: that everyone should have access to powerful tools for studying God\'s Word. We combine modern technology with timeless wisdom to create an experience that helps believers grow in their faith and understanding.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Whether you\'re a new believer taking your first steps in faith or a seasoned student of scripture, our platform provides the resources and community support you need to deepen your relationship with God through His Word.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Features Section
          Text(
            'What We Offer',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            feature.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        feature.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        feature.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Team Section
          Text(
            'Meet Our Team',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: teamMembers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final member = teamMembers[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            member.image,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              member.role,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              member.bio,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Values Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Values',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _ValueItem(
                    icon: '🙏',
                    title: 'Faith-Centered',
                    description: 'Everything we do is grounded in faith and reverence for God\'s Word.',
                  ),
                  const SizedBox(height: 16),
                  const _ValueItem(
                    icon: '🤝',
                    title: 'Community',
                    description: 'We believe in the power of studying scripture together in fellowship.',
                  ),
                  const SizedBox(height: 16),
                  const _ValueItem(
                    icon: '📖',
                    title: 'Accessibility',
                    description: 'Making Bible study tools available to everyone, regardless of background or experience.',
                  ),
                  const SizedBox(height: 16),
                  const _ValueItem(
                    icon: '💡',
                    title: 'Innovation',
                    description: 'Using technology thoughtfully to enhance, not replace, traditional study methods.',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Contact Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get in Touch',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Have questions, suggestions, or feedback? We\'d love to hear from you!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  const _ContactItem(
                    icon: Icons.email,
                    title: 'Email',
                    content: 'support@biblestudy.com',
                  ),
                  const SizedBox(height: 12),
                  const _ContactItem(
                    icon: Icons.favorite,
                    title: 'Prayer Requests',
                    content: 'prayers@biblestudy.com',
                  ),
                  const SizedBox(height: 12),
                  const _ContactItem(
                    icon: Icons.help,
                    title: 'Technical Support',
                    content: 'help@biblestudy.com',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueItem extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _ValueItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          '$title: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
