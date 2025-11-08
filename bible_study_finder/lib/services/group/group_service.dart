import '../../models/group/bible_study_group.dart';
import '../../models/group/search_criteria.dart';
import '../../apis/group/group_api.dart';
import '../../services/membership/membership_service.dart';
import '../../utils/logger.dart';
import '../../utils/auth_storage.dart';

class GroupService {
  static final _logger = getLogger('GroupService');

  static Future<List<BibleStudyGroup>> getGroups() async {
    try {
      final allGroups = await GroupApi.getGroupsApi();
      final groupsWithMembership = await _markMembershipStatus(allGroups);
      return groupsWithMembership;
    } catch (e, stackTrace) {
      _logger.error('Error fetching groups', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching groups: $e');
    }
  }

  static Future<List<BibleStudyGroup>> _markMembershipStatus(
      List<BibleStudyGroup> groups) async {
    try {
      final userId = await AuthStorage.getUserId();
      if (userId == null) {
        return groups;
      }

      final userGroups = await MembershipService.getMyGroups();
      final userGroupIds = userGroups.map((g) => g.id).toSet();

      return groups.map((group) {
        final isMember = userGroupIds.contains(group.id);
        return group.copyWith(isMember: isMember);
      }).toList();
    } catch (e) {
      _logger.warning('Error fetching user groups for membership check: $e');
      return groups;
    }
  }

  static Future<List<BibleStudyGroup>> searchGroups(
      SearchCriteria criteria) async {
    try {
      final allGroups = await getGroups();
      List<BibleStudyGroup> filteredGroups = List.from(allGroups);
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
    } catch (e, stackTrace) {
      _logger.error('Error searching groups', error: e, stackTrace: stackTrace);
      throw Exception('Error searching groups: $e');
    }
  }

  static Future<BibleStudyGroup> getGroup(String groupId) async {
    try {
      return await GroupApi.getGroupApi(groupId);
    } catch (e, stackTrace) {
      _logger.error('Error fetching group', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching group: $e');
    }
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
