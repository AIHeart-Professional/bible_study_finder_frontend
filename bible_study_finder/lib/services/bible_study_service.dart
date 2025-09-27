import '../models/bible_study_group.dart';
import '../models/search_criteria.dart';
import '../models/study_plan.dart';
import '../models/church.dart';

class BibleStudyService {
  static const List<BibleStudyGroup> _placeholderGroups = [
    BibleStudyGroup(
      id: 1,
      name: "Romans Study Group",
      description: "Deep dive into Paul's letter to the Romans. We explore themes of grace, faith, and righteousness in a welcoming environment.",
      image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=200&fit=crop&crop=face",
      location: "Downtown Community Church, Seattle, WA",
      meetingDay: "Wednesday",
      meetingTime: "7:00 PM - 8:30 PM",
      studyType: "Verse by Verse",
      ageGroup: "Adults (25-55)",
      language: "English",
      groupSize: 12,
      isOnline: false,
      isInPerson: true,
      isChildcareAvailable: true,
      isBeginnersWelcome: true,
      distance: 2.3,
    ),
    BibleStudyGroup(
      id: 2,
      name: "Women's Prayer & Study",
      description: "A supportive community of women studying various books of the Bible with emphasis on prayer and fellowship.",
      image: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&h=200&fit=crop&crop=face",
      location: "Grace Fellowship, Bellevue, WA",
      meetingDay: "Tuesday",
      meetingTime: "10:00 AM - 11:30 AM",
      studyType: "Topical Study",
      ageGroup: "Mixed Ages",
      language: "English",
      groupSize: 18,
      isOnline: false,
      isInPerson: true,
      isChildcareAvailable: true,
      isBeginnersWelcome: true,
      distance: 5.7,
    ),
    BibleStudyGroup(
      id: 3,
      name: "Young Adults Bible Study",
      description: "Casual and engaging Bible study for young professionals. We tackle real-life applications of Biblical principles.",
      image: "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=300&h=200&fit=crop&crop=face",
      location: "Online via Zoom",
      meetingDay: "Thursday",
      meetingTime: "7:30 PM - 9:00 PM",
      studyType: "Topical Study",
      ageGroup: "Young Adults (18-30)",
      language: "English",
      groupSize: 15,
      isOnline: true,
      isInPerson: false,
      isChildcareAvailable: false,
      isBeginnersWelcome: true,
      distance: 0,
    ),
    BibleStudyGroup(
      id: 4,
      name: "Psalms & Worship Study",
      description: "Explore the beauty of Psalms while incorporating worship and music. Perfect for those who love both study and song.",
      image: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop&crop=face",
      location: "Hillside Baptist Church, Redmond, WA",
      meetingDay: "Sunday",
      meetingTime: "6:00 PM - 7:30 PM",
      studyType: "Book Study",
      ageGroup: "Mixed Ages",
      language: "English",
      groupSize: 25,
      isOnline: false,
      isInPerson: true,
      isChildcareAvailable: false,
      isBeginnersWelcome: true,
      distance: 8.2,
    ),
    BibleStudyGroup(
      id: 5,
      name: "Spanish Bible Study",
      description: "Estudio bíblico en español para toda la familia. Exploramos las escrituras en un ambiente acogedor y familiar.",
      image: "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=300&h=200&fit=crop&crop=face",
      location: "Iglesia Emanuel, Seattle, WA",
      meetingDay: "Saturday",
      meetingTime: "4:00 PM - 5:30 PM",
      studyType: "Bible Study",
      ageGroup: "Mixed Ages",
      language: "Spanish",
      groupSize: 20,
      isOnline: false,
      isInPerson: true,
      isChildcareAvailable: true,
      isBeginnersWelcome: true,
      distance: 4.1,
    ),
    BibleStudyGroup(
      id: 6,
      name: "Senior Saints Study",
      description: "A warm and welcoming group for seniors to study God's word together, share life experiences, and encourage one another.",
      image: "https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=300&h=200&fit=crop&crop=face",
      location: "First Methodist Church, Kirkland, WA",
      meetingDay: "Wednesday",
      meetingTime: "2:00 PM - 3:30 PM",
      studyType: "Bible Study",
      ageGroup: "Seniors (55+)",
      language: "English",
      groupSize: 14,
      isOnline: false,
      isInPerson: true,
      isChildcareAvailable: false,
      isBeginnersWelcome: true,
      distance: 6.8,
    ),
    BibleStudyGroup(
      id: 7,
      name: "Men's Morning Study",
      description: "Early morning Bible study for men before work. Strong coffee, solid teaching, and brotherhood in Christ.",
      image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=200&fit=crop&crop=face",
      location: "CrossPoint Church, Bothell, WA",
      meetingDay: "Friday",
      meetingTime: "6:30 AM - 7:30 AM",
      studyType: "Book Study",
      ageGroup: "Adults (31-55)",
      language: "English",
      groupSize: 10,
      isOnline: false,
      isInPerson: true,
      isChildcareAvailable: false,
      isBeginnersWelcome: true,
      distance: 12.5,
    ),
    BibleStudyGroup(
      id: 8,
      name: "Hybrid Family Study",
      description: "Family-friendly Bible study available both in-person and online. Great for busy families wanting flexibility.",
      image: "https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=300&h=200&fit=crop&crop=face",
      location: "New Life Church, Issaquah, WA (+ Online)",
      meetingDay: "Sunday",
      meetingTime: "11:30 AM - 12:30 PM",
      studyType: "Topical Study",
      ageGroup: "Mixed Ages",
      language: "English",
      groupSize: 30,
      isOnline: true,
      isInPerson: true,
      isChildcareAvailable: true,
      isBeginnersWelcome: true,
      distance: 15.3,
    ),
  ];

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

  // Simulate API call with minimal delay for better UX
  static Future<List<BibleStudyGroup>> searchGroups(SearchCriteria criteria) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Reduced from 1 second
    
    List<BibleStudyGroup> filteredGroups = List.from(_placeholderGroups);

    // Filter by meeting type
    if (criteria.isOnline && !criteria.isInPerson) {
      filteredGroups = filteredGroups.where((group) => group.isOnline).toList();
    } else if (!criteria.isOnline && criteria.isInPerson) {
      filteredGroups = filteredGroups.where((group) => group.isInPerson).toList();
    }

    // Filter by study type
    if (criteria.studyType.isNotEmpty) {
      filteredGroups = filteredGroups.where((group) =>
          group.studyType.toLowerCase().contains(criteria.studyType.toLowerCase())).toList();
    }

    // Filter by meeting day
    if (criteria.meetingDay.isNotEmpty) {
      filteredGroups = filteredGroups.where((group) =>
          group.meetingDay.toLowerCase() == criteria.meetingDay.toLowerCase()).toList();
    }

    // Filter by language
    if (criteria.language.isNotEmpty) {
      filteredGroups = filteredGroups.where((group) =>
          group.language.toLowerCase() == criteria.language.toLowerCase()).toList();
    }

    // Filter by distance
    if (criteria.maxDistance > 0) {
      filteredGroups = filteredGroups.where((group) =>
          group.distance <= criteria.maxDistance).toList();
    }

    // Filter by group size
    if (criteria.groupSize > 0) {
      filteredGroups = filteredGroups.where((group) =>
          group.groupSize <= criteria.groupSize).toList();
    }

    // Filter by childcare availability
    if (criteria.isChildcareAvailable) {
      filteredGroups = filteredGroups.where((group) => group.isChildcareAvailable).toList();
    }

    // Filter by beginners welcome
    if (criteria.isBeginnersWelcome) {
      filteredGroups = filteredGroups.where((group) => group.isBeginnersWelcome).toList();
    }

    // Filter by search term (name or description)
    if (criteria.searchTerm.trim().isNotEmpty) {
      final searchTerm = criteria.searchTerm.toLowerCase().trim();
      filteredGroups = filteredGroups.where((group) =>
          group.name.toLowerCase().contains(searchTerm) ||
          group.description.toLowerCase().contains(searchTerm)).toList();
    }

    return filteredGroups;
  }

  static List<StudyPlan> getStudyPlans() {
    return List.from(_studyPlans);
  }

  static List<Map<String, String>> getStudyTypeOptions() {
    return [
      {'value': '', 'label': 'Any Study Type'},
      {'value': 'bible-study', 'label': 'Bible Study'},
      {'value': 'book-study', 'label': 'Book Study'},
      {'value': 'topical', 'label': 'Topical Study'},
      {'value': 'verse-by-verse', 'label': 'Verse by Verse'},
      {'value': 'womens', 'label': "Women's Study"},
      {'value': 'mens', 'label': "Men's Study"},
      {'value': 'youth', 'label': 'Youth Study'},
      {'value': 'seniors', 'label': 'Seniors Study'},
    ];
  }

  static List<Map<String, String>> getMeetingDayOptions() {
    return [
      {'value': '', 'label': 'Any Day'},
      {'value': 'sunday', 'label': 'Sunday'},
      {'value': 'monday', 'label': 'Monday'},
      {'value': 'tuesday', 'label': 'Tuesday'},
      {'value': 'wednesday', 'label': 'Wednesday'},
      {'value': 'thursday', 'label': 'Thursday'},
      {'value': 'friday', 'label': 'Friday'},
      {'value': 'saturday', 'label': 'Saturday'},
    ];
  }

  static List<Map<String, String>> getMeetingTimeOptions() {
    return [
      {'value': '', 'label': 'Any Time'},
      {'value': 'morning', 'label': 'Morning (6AM - 12PM)'},
      {'value': 'afternoon', 'label': 'Afternoon (12PM - 6PM)'},
      {'value': 'evening', 'label': 'Evening (6PM - 10PM)'},
    ];
  }

  static List<Map<String, String>> getAgeGroupOptions() {
    return [
      {'value': '', 'label': 'Any Age Group'},
      {'value': 'teens', 'label': 'Teens (13-17)'},
      {'value': 'young-adults', 'label': 'Young Adults (18-30)'},
      {'value': 'adults', 'label': 'Adults (31-55)'},
      {'value': 'seniors', 'label': 'Seniors (55+)'},
      {'value': 'mixed', 'label': 'Mixed Ages'},
    ];
  }

  static List<Map<String, String>> getLanguageOptions() {
    return [
      {'value': '', 'label': 'Any Language'},
      {'value': 'english', 'label': 'English'},
      {'value': 'spanish', 'label': 'Spanish'},
      {'value': 'korean', 'label': 'Korean'},
      {'value': 'chinese', 'label': 'Chinese'},
      {'value': 'portuguese', 'label': 'Portuguese'},
      {'value': 'french', 'label': 'French'},
    ];
  }

  // Church-related methods
  static const List<Church> _placeholderChurches = [
    Church(
      id: '1',
      name: 'Grace Community Church',
      denomination: 'Non-denominational',
      address: '123 Main Street',
      city: 'Seattle',
      state: 'WA',
      zipCode: '98101',
      latitude: 47.6062,
      longitude: -122.3321,
      phoneNumber: '(206) 555-0123',
      website: 'https://gracecommunity.org',
      email: 'info@gracecommunity.org',
      pastorName: 'Pastor John Smith',
      serviceTypes: ['Traditional', 'Contemporary', 'Youth'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '9:00 AM',
          type: 'Traditional Service',
          description: 'Classic hymns and liturgical worship',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '11:00 AM',
          type: 'Contemporary Service',
          description: 'Modern worship with contemporary music',
        ),
        ServiceTime(
          dayOfWeek: 'Wednesday',
          time: '7:00 PM',
          type: 'Bible Study',
          description: 'Midweek Bible study and prayer',
        ),
      ],
      ministries: ['Youth Ministry', 'Women\'s Ministry', 'Men\'s Ministry', 'Children\'s Ministry', 'Seniors Ministry'],
      description: 'A welcoming community church focused on worship, fellowship, and serving our neighborhood. We believe in the power of God\'s love to transform lives.',
      distance: 2.1,
      rating: 4.8,
      reviewCount: 127,
      photos: ['church1.jpg', 'church2.jpg'],
      hasChildcare: true,
      hasYouthProgram: true,
      isWheelchairAccessible: true,
      hasParking: true,
    ),
    Church(
      id: '2',
      name: 'First Baptist Church',
      denomination: 'Baptist',
      address: '456 Oak Avenue',
      city: 'Bellevue',
      state: 'WA',
      zipCode: '98004',
      latitude: 47.6101,
      longitude: -122.2015,
      phoneNumber: '(425) 555-0456',
      website: 'https://firstbaptistbellevue.org',
      email: 'welcome@firstbaptist.org',
      pastorName: 'Pastor David Johnson',
      serviceTypes: ['Traditional', 'Family'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '10:30 AM',
          type: 'Sunday Worship',
          description: 'Family-friendly worship service',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '6:00 PM',
          type: 'Evening Service',
          description: 'Reflective evening worship',
        ),
        ServiceTime(
          dayOfWeek: 'Thursday',
          time: '7:30 PM',
          type: 'Prayer Meeting',
          description: 'Community prayer and fellowship',
        ),
      ],
      ministries: ['Missions', 'Music Ministry', 'Food Pantry', 'Senior Care', 'Bible Study Groups'],
      description: 'Established in 1952, we are a Bible-believing church committed to sharing God\'s love through worship, discipleship, and community outreach.',
      distance: 5.3,
      rating: 4.6,
      reviewCount: 89,
      photos: ['baptist1.jpg', 'baptist2.jpg'],
      hasChildcare: true,
      hasYouthProgram: true,
      isWheelchairAccessible: true,
      hasParking: true,
    ),
    Church(
      id: '3',
      name: 'St. Mark\'s Lutheran Church',
      denomination: 'Lutheran (ELCA)',
      address: '789 Pine Street',
      city: 'Seattle',
      state: 'WA',
      zipCode: '98122',
      latitude: 47.6205,
      longitude: -122.3212,
      phoneNumber: '(206) 555-0789',
      website: 'https://stmarklutheran.org',
      email: 'office@stmarklutheran.org',
      pastorName: 'Pastor Sarah Williams',
      serviceTypes: ['Traditional', 'Liturgical'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '8:00 AM',
          type: 'Early Service',
          description: 'Quiet contemplative worship',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '10:30 AM',
          type: 'Main Service',
          description: 'Full liturgical service with choir',
        ),
      ],
      ministries: ['Social Justice', 'Community Garden', 'Adult Education', 'Confirmation', 'Choir'],
      description: 'A progressive Lutheran congregation committed to justice, inclusion, and spiritual growth. All are welcome at God\'s table.',
      distance: 1.8,
      rating: 4.7,
      reviewCount: 94,
      photos: ['lutheran1.jpg'],
      hasChildcare: true,
      hasYouthProgram: false,
      isWheelchairAccessible: true,
      hasParking: false,
    ),
    Church(
      id: '4',
      name: 'New Life Pentecostal Church',
      denomination: 'Pentecostal',
      address: '321 Second Avenue',
      city: 'Renton',
      state: 'WA',
      zipCode: '98055',
      latitude: 47.4829,
      longitude: -122.2171,
      phoneNumber: '(425) 555-0321',
      website: 'https://newlifepentecostal.org',
      email: 'info@newlifepentecostal.org',
      pastorName: 'Pastor Michael Garcia',
      serviceTypes: ['Contemporary', 'Bilingual', 'Healing'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '9:30 AM',
          type: 'English Service',
          description: 'Contemporary worship in English',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '12:00 PM',
          type: 'Spanish Service',
          description: 'Servicio en Español',
        ),
        ServiceTime(
          dayOfWeek: 'Friday',
          time: '7:00 PM',
          type: 'Prayer & Healing',
          description: 'Prayer meeting with healing ministry',
        ),
      ],
      ministries: ['Hispanic Ministry', 'Healing Ministry', 'Youth Group', 'Women\'s Circle', 'Men\'s Fellowship'],
      description: 'A Spirit-filled church welcoming people from all backgrounds. We believe in the power of prayer, healing, and the gifts of the Holy Spirit.',
      distance: 8.2,
      rating: 4.9,
      reviewCount: 156,
      photos: ['pentecostal1.jpg', 'pentecostal2.jpg', 'pentecostal3.jpg'],
      hasChildcare: true,
      hasYouthProgram: true,
      isWheelchairAccessible: true,
      hasParking: true,
    ),
    Church(
      id: '5',
      name: 'Unity Christian Fellowship',
      denomination: 'Non-denominational',
      address: '555 Broadway',
      city: 'Tacoma',
      state: 'WA',
      zipCode: '98402',
      latitude: 47.2529,
      longitude: -122.4443,
      phoneNumber: '(253) 555-0555',
      website: 'https://unitychristian.org',
      email: 'connect@unitychristian.org',
      pastorName: 'Pastor Jennifer Brown',
      serviceTypes: ['Contemporary', 'Family', 'Outdoor'],
      serviceTimes: [
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '10:00 AM',
          type: 'Family Worship',
          description: 'All-ages worship with interactive elements',
        ),
        ServiceTime(
          dayOfWeek: 'Sunday',
          time: '6:00 PM',
          type: 'Evening Gathering',
          description: 'Informal worship and discussion',
        ),
      ],
      ministries: ['Community Outreach', 'Environmental Stewardship', 'Artistic Expression', 'Small Groups'],
      description: 'A diverse, creative community exploring faith through worship, art, and service. We emphasize God\'s love for all creation.',
      distance: 15.7,
      rating: 4.5,
      reviewCount: 63,
      photos: ['unity1.jpg'],
      hasChildcare: true,
      hasYouthProgram: true,
      isWheelchairAccessible: true,
      hasParking: true,
    ),
  ];

  static Future<List<Church>> searchChurches(String? location, {
    String? denomination,
    double maxDistance = 25.0,
    List<String> preferredServices = const [],
  }) async {
    // Simulate API call with minimal delay for better UX
    await Future.delayed(const Duration(milliseconds: 50)); // Reduced from 800ms
    
    List<Church> results = List.from(_placeholderChurches);
    
    // Filter by denomination
    if (denomination != null && denomination.isNotEmpty) {
      results = results.where((church) => 
        church.denomination.toLowerCase().contains(denomination.toLowerCase())
      ).toList();
    }
    
    // Filter by distance
    results = results.where((church) => church.distance <= maxDistance).toList();
    
    // Sort by distance (closest first)
    results.sort((a, b) => a.distance.compareTo(b.distance));
    
    return results;
  }

  static List<String> getDenominationOptions() {
    return [
      'Non-denominational',
      'Baptist',
      'Methodist',
      'Presbyterian',
      'Lutheran',
      'Pentecostal',
      'Catholic',
      'Episcopal',
      'Assemblies of God',
      'Christian Reformed',
      'Evangelical',
      'Orthodox',
    ];
  }

  static List<String> getServiceTypeOptions() {
    return [
      'Traditional',
      'Contemporary',
      'Liturgical',
      'Family-friendly',
      'Youth-oriented',
      'Bilingual',
      'Outdoor',
      'Online',
    ];
  }
}

