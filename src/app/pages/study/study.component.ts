import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-study',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './study.component.html',
  styleUrls: ['./study.component.scss']
})
export class StudyComponent {
  studyPlans = [
    {
      title: 'New Testament Overview',
      description: 'A comprehensive journey through the New Testament books.',
      duration: '30 days',
      difficulty: 'Beginner',
      progress: 0
    },
    {
      title: 'Psalms Deep Dive',
      description: 'Explore the beautiful poetry and worship in the book of Psalms.',
      duration: '60 days',
      difficulty: 'Intermediate',
      progress: 25
    },
    {
      title: 'Gospel of John',
      description: 'Discover the divinity of Christ through John\'s Gospel.',
      duration: '21 days',
      difficulty: 'Beginner',
      progress: 75
    }
  ];

  currentVerse = {
    reference: 'John 3:16',
    text: 'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.'
  };
}
