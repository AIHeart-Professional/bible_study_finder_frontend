class SearchCriteria {
  final String searchTerm;
  final String location;
  final String studyType;
  final String meetingDay;
  final String meetingTime;
  final String ageGroup;
  final String language;
  final int maxDistance;
  final int groupSize;
  final bool isOnline;
  final bool isInPerson;
  final bool isChildcareAvailable;
  final bool isBeginnersWelcome;

  const SearchCriteria({
    this.searchTerm = '',
    this.location = '',
    this.studyType = '',
    this.meetingDay = '',
    this.meetingTime = '',
    this.ageGroup = '',
    this.language = '',
    this.maxDistance = 25,
    this.groupSize = 50,
    this.isOnline = false,
    this.isInPerson = true,
    this.isChildcareAvailable = false,
    this.isBeginnersWelcome = true,
  });

  SearchCriteria copyWith({
    String? searchTerm,
    String? location,
    String? studyType,
    String? meetingDay,
    String? meetingTime,
    String? ageGroup,
    String? language,
    int? maxDistance,
    int? groupSize,
    bool? isOnline,
    bool? isInPerson,
    bool? isChildcareAvailable,
    bool? isBeginnersWelcome,
  }) {
    return SearchCriteria(
      searchTerm: searchTerm ?? this.searchTerm,
      location: location ?? this.location,
      studyType: studyType ?? this.studyType,
      meetingDay: meetingDay ?? this.meetingDay,
      meetingTime: meetingTime ?? this.meetingTime,
      ageGroup: ageGroup ?? this.ageGroup,
      language: language ?? this.language,
      maxDistance: maxDistance ?? this.maxDistance,
      groupSize: groupSize ?? this.groupSize,
      isOnline: isOnline ?? this.isOnline,
      isInPerson: isInPerson ?? this.isInPerson,
      isChildcareAvailable: isChildcareAvailable ?? this.isChildcareAvailable,
      isBeginnersWelcome: isBeginnersWelcome ?? this.isBeginnersWelcome,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'searchTerm': searchTerm,
      'location': location,
      'studyType': studyType,
      'meetingDay': meetingDay,
      'meetingTime': meetingTime,
      'ageGroup': ageGroup,
      'language': language,
      'maxDistance': maxDistance,
      'groupSize': groupSize,
      'isOnline': isOnline,
      'isInPerson': isInPerson,
      'isChildcareAvailable': isChildcareAvailable,
      'isBeginnersWelcome': isBeginnersWelcome,
    };
  }
}

