class StudyPlan {
  final int id;
  final String title;
  final String description;
  final String duration;
  final String difficulty;
  final int progress;

  const StudyPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.progress,
  });

  factory StudyPlan.fromJson(Map<String, dynamic> json) {
    return StudyPlan(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      difficulty: json['difficulty'] ?? 'Beginner',
      progress: json['progress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'progress': progress,
    };
  }
}

class DailyVerse {
  final String reference;
  final String text;

  const DailyVerse({
    required this.reference,
    required this.text,
  });

  factory DailyVerse.fromJson(Map<String, dynamic> json) {
    return DailyVerse(
      reference: json['reference'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'text': text,
    };
  }
}

