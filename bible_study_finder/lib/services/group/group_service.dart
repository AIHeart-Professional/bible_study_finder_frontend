import '../../models/group/bible_study_group.dart';
import '../../models/group/search_criteria.dart';
import '../../apis/group/group_api.dart';
import '../../utils/logger.dart';

class GroupService {
  static final _logger = getLogger('GroupService');

  static Future<List<BibleStudyGroup>> getGroups() async {
    try {
      return await GroupApi.getGroupsApi();
    } catch (e, stackTrace) {
      _logger.error('Error fetching groups', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching groups: $e');
    }
  }

  static const List<BibleStudyGroup> _placeholderGroups = [
    BibleStudyGroup(
      id: '1',
      name: "Romans Study Group",
      description:
          "Deep dive into Paul's letter to the Romans. We explore themes of grace, faith, and righteousness in a welcoming environment.",
      image:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=200&fit=crop&crop=face",
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
      id: '2',
      name: "Women's Prayer & Study",
      description:
          "A supportive community of women studying various books of the Bible with emphasis on prayer and fellowship.",
      image:
          "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&h=200&fit=crop&crop=face",
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
      id: '3',
      name: "Young Adults Bible Study",
      description:
          "Casual and engaging Bible study for young professionals. We tackle real-life applications of Biblical principles.",
      image:
          "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=300&h=200&fit=crop&crop=face",
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
      id: '4',
      name: "Psalms & Worship Study",
      description:
          "Explore the beauty of Psalms while incorporating worship and music. Perfect for those who love both study and song.",
      image:
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop&crop=face",
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
      id: '5',
      name: "Spanish Bible Study",
      description:
          "Estudio bíblico en español para toda la familia. Exploramos las escrituras en un ambiente acogedor y familiar.",
      image:
          "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=300&h=200&fit=crop&crop=face",
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
      id: '6',
      name: "Senior Saints Study",
      description:
          "A warm and welcoming group for seniors to study God's word together, share life experiences, and encourage one another.",
      image:
          "https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=300&h=200&fit=crop&crop=face",
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
      id: '7',
      name: "Men's Morning Study",
      description:
          "Early morning Bible study for men before work. Strong coffee, solid teaching, and brotherhood in Christ.",
      image:
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=200&fit=crop&crop=face",
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
      id: '8',
      name: "Hybrid Family Study",
      description:
          "Family-friendly Bible study available both in-person and online. Great for busy families wanting flexibility.",
      image:
          "https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=300&h=200&fit=crop&crop=face",
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

  static Future<List<BibleStudyGroup>> searchGroups(
      SearchCriteria criteria) async {
    await Future.delayed(const Duration(milliseconds: 100));

    List<BibleStudyGroup> filteredGroups = List.from(_placeholderGroups);
    filteredGroups = _filterByMeetingType(filteredGroups, criteria);
    filteredGroups = _filterByStudyType(filteredGroups, criteria);
    filteredGroups = _filterByMeetingDay(filteredGroups, criteria);
    filteredGroups = _filterByLanguage(filteredGroups, criteria);
    filteredGroups = _filterByDistance(filteredGroups, criteria);
    filteredGroups = _filterByGroupSize(filteredGroups, criteria);
    filteredGroups = _filterByChildcare(filteredGroups, criteria);
    filteredGroups = _filterByBeginnersWelcome(filteredGroups, criteria);
    filteredGroups = _filterBySearchTerm(filteredGroups, criteria);

    return filteredGroups;
  }

  static List<BibleStudyGroup> _filterByMeetingType(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    if (criteria.isOnline && !criteria.isInPerson) {
      return groups.where((group) => group.isOnline).toList();
    } else if (!criteria.isOnline && criteria.isInPerson) {
      return groups.where((group) => group.isInPerson).toList();
    }
    return groups;
  }

  static List<BibleStudyGroup> _filterByStudyType(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    if (criteria.studyType.isEmpty) {
      return groups;
    }
    final studyType = criteria.studyType.toLowerCase();
    return groups
        .where((group) =>
            group.studyType?.toLowerCase().contains(studyType) ?? false)
        .toList();
  }

  static List<BibleStudyGroup> _filterByMeetingDay(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    if (criteria.meetingDay.isEmpty) {
      return groups;
    }
    final meetingDay = criteria.meetingDay.toLowerCase();
    return groups
        .where((group) => group.meetingDay?.toLowerCase() == meetingDay)
        .toList();
  }

  static List<BibleStudyGroup> _filterByLanguage(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    if (criteria.language.isEmpty) {
      return groups;
    }
    final language = criteria.language.toLowerCase();
    return groups
        .where((group) => group.language?.toLowerCase() == language)
        .toList();
  }

  static List<BibleStudyGroup> _filterByDistance(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    if (criteria.maxDistance <= 0) {
      return groups;
    }
    return groups
        .where((group) => group.distance <= criteria.maxDistance)
        .toList();
  }

  static List<BibleStudyGroup> _filterByGroupSize(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    if (criteria.groupSize <= 0) {
      return groups;
    }
    return groups
        .where((group) => (group.groupSize ?? 0) <= criteria.groupSize)
        .toList();
  }

  static List<BibleStudyGroup> _filterByChildcare(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    if (!criteria.isChildcareAvailable) {
      return groups;
    }
    return groups.where((group) => group.isChildcareAvailable).toList();
  }

  static List<BibleStudyGroup> _filterByBeginnersWelcome(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    if (!criteria.isBeginnersWelcome) {
      return groups;
    }
    return groups.where((group) => group.isBeginnersWelcome).toList();
  }

  static List<BibleStudyGroup> _filterBySearchTerm(
      List<BibleStudyGroup> groups, SearchCriteria criteria) {
    final searchTerm = criteria.searchTerm.trim().toLowerCase();
    if (searchTerm.isEmpty) {
      return groups;
    }
    return groups
        .where((group) =>
            group.name.toLowerCase().contains(searchTerm) ||
            group.description.toLowerCase().contains(searchTerm))
        .toList();
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
}
