import '../models/study/study_plan.dart';

class StudyPlanService {
  static const List<StudyPlan> _studyPlans = [
    StudyPlan(
      id: 1,
      title: 'New Testament Overview',
      description: 'A comprehensive journey through the New Testament books.',
      duration: '30 days',
      difficulty: 'Beginner',
      progress: 0,
    ),
    StudyPlan(
      id: 2,
      title: 'Psalms Deep Dive',
      description: 'Explore the beautiful poetry and worship in the book of Psalms.',
      duration: '60 days',
      difficulty: 'Intermediate',
      progress: 25,
    ),
    StudyPlan(
      id: 3,
      title: 'Gospel of John',
      description: 'Discover the divinity of Christ through John\'s Gospel.',
      duration: '21 days',
      difficulty: 'Beginner',
      progress: 75,
    ),
  ];

  static List<StudyPlan> getStudyPlans() {
    return List.from(_studyPlans);
  }
}
