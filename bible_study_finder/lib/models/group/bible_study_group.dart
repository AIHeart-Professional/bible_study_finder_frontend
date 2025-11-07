class BibleStudyGroup {
  final int id;
  final String name;
  final String description;
  final String image;
  final String location;
  final String meetingDay;
  final String meetingTime;
  final String studyType;
  final String ageGroup;
  final String language;
  final int groupSize;
  final bool isOnline;
  final bool isInPerson;
  final bool isChildcareAvailable;
  final bool isBeginnersWelcome;
  final double distance;

  const BibleStudyGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.location,
    required this.meetingDay,
    required this.meetingTime,
    required this.studyType,
    required this.ageGroup,
    required this.language,
    required this.groupSize,
    required this.isOnline,
    required this.isInPerson,
    required this.isChildcareAvailable,
    required this.isBeginnersWelcome,
    required this.distance,
  });

  factory BibleStudyGroup.fromJson(Map<String, dynamic> json) {
    return BibleStudyGroup(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      meetingDay: json['meetingDay'] ?? '',
      meetingTime: json['meetingTime'] ?? '',
      studyType: json['studyType'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      language: json['language'] ?? '',
      groupSize: json['groupSize'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      isInPerson: json['isInPerson'] ?? false,
      isChildcareAvailable: json['isChildcareAvailable'] ?? false,
      isBeginnersWelcome: json['isBeginnersWelcome'] ?? false,
      distance: json['distance']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'location': location,
      'meetingDay': meetingDay,
      'meetingTime': meetingTime,
      'studyType': studyType,
      'ageGroup': ageGroup,
      'language': language,
      'groupSize': groupSize,
      'isOnline': isOnline,
      'isInPerson': isInPerson,
      'isChildcareAvailable': isChildcareAvailable,
      'isBeginnersWelcome': isBeginnersWelcome,
      'distance': distance,
    };
  }
}

