import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-about',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.scss']
})
export class AboutComponent {
  teamMembers = [
    {
      name: 'Sarah Johnson',
      role: 'Lead Developer',
      bio: 'Passionate about creating technology that brings people closer to God\'s Word.',
      image: '👩‍💻'
    },
    {
      name: 'Michael Chen',
      role: 'UX Designer',
      bio: 'Dedicated to making Bible study accessible and engaging for everyone.',
      image: '👨‍🎨'
    },
    {
      name: 'Pastor David Williams',
      role: 'Content Advisor',
      bio: 'Ensuring theological accuracy and spiritual depth in our study materials.',
      image: '👨‍🏫'
    }
  ];

  features = [
    {
      title: 'Comprehensive Study Tools',
      description: 'Access commentaries, concordances, and cross-references to deepen your understanding.',
      icon: '🛠️'
    },
    {
      title: 'Community Engagement',
      description: 'Join study groups, share insights, and learn from fellow believers worldwide.',
      icon: '🤝'
    },
    {
      title: 'Progress Tracking',
      description: 'Monitor your reading progress and maintain consistent study habits.',
      icon: '📈'
    },
    {
      title: 'Multiple Translations',
      description: 'Compare verses across different Bible translations for deeper insight.',
      icon: '📚'
    }
  ];
}
