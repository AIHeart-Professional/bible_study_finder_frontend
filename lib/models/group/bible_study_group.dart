import 'location.dart';

class BibleStudyGroup {
  final String id;
  final String name;
  final String description;
  final String? image;
  final String location;
  final Location? locationData;
  final String? meetingDay;
  final String? meetingTime;
  final String? studyType;
  final String? ageGroup;
  final String? language;
  final int? groupSize;
  final bool isOnline;
  final bool isInPerson;
  final bool isChildcareAvailable;
  final bool isBeginnersWelcome;
  final double distance;
  final String? leaderUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isMember;

  const BibleStudyGroup({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.location,
    this.locationData,
    this.meetingDay,
    this.meetingTime,
    this.studyType,
    this.ageGroup,
    this.language,
    this.groupSize,
    this.isOnline = false,
    this.isInPerson = false,
    this.isChildcareAvailable = false,
    this.isBeginnersWelcome = false,
    this.distance = 0.0,
    this.leaderUserId,
    this.createdAt,
    this.updatedAt,
    this.isMember = false,
  });

  factory BibleStudyGroup.fromJson(Map<String, dynamic> json) {
    final locationObj = json['location'];
    final locationData = locationObj is Map<String, dynamic>
        ? Location.fromJson(locationObj)
        : null;
    
    final locationString = locationData?.getDisplayString() ?? 
        (json['location'] is String ? json['location'] : 'Location not specified');
    
    final idValue = json['id'];
    final id = idValue is String ? idValue : idValue.toString();
    
    final createdAtStr = json['createdAt'];
    final updatedAtStr = json['updatedAt'];
    
    DateTime? parseDateTime(dynamic dateStr) {
      if (dateStr == null) return null;
      if (dateStr is DateTime) return dateStr;
      if (dateStr is String) {
        try {
          return DateTime.parse(dateStr);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    final isOnline = locationData?.virtualMeetingLink != null;
    final isInPerson = locationData?.address != null || 
        locationData?.city != null;

    return BibleStudyGroup(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      location: locationString,
      locationData: locationData,
      meetingDay: json['meetingDay'],
      meetingTime: json['meetingTime'],
      studyType: json['studyType'],
      ageGroup: json['ageGroup'],
      language: json['language'],
      groupSize: json['groupSize'],
      isOnline: json['isOnline'] ?? isOnline,
      isInPerson: json['isInPerson'] ?? isInPerson,
      isChildcareAvailable: json['isChildcareAvailable'] ?? false,
      isBeginnersWelcome: json['isBeginnersWelcome'] ?? false,
      distance: json['distance']?.toDouble() ?? 0.0,
      leaderUserId: json['leaderUserId'],
      createdAt: parseDateTime(createdAtStr),
      updatedAt: parseDateTime(updatedAtStr),
      isMember: json['isMember'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'location': location,
      'locationData': locationData?.toJson(),
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
      'leaderUserId': leaderUserId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isMember': isMember,
    };
  }

  BibleStudyGroup copyWith({bool? isMember}) {
    return BibleStudyGroup(
      id: id,
      name: name,
      description: description,
      image: image,
      location: location,
      locationData: locationData,
      meetingDay: meetingDay,
      meetingTime: meetingTime,
      studyType: studyType,
      ageGroup: ageGroup,
      language: language,
      groupSize: groupSize,
      isOnline: isOnline,
      isInPerson: isInPerson,
      isChildcareAvailable: isChildcareAvailable,
      isBeginnersWelcome: isBeginnersWelcome,
      distance: distance,
      leaderUserId: leaderUserId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isMember: isMember ?? this.isMember,
    );
  }
}

