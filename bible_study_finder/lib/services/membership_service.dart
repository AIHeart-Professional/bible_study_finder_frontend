import '../models/group/bible_study_group.dart';
import '../models/group/user_group_membership.dart';

class MembershipService {
  static Future<bool> isMemberOfGroup(String groupId) async {
    // Simulate API call with minimal delay
    await Future.delayed(const Duration(milliseconds: 50));
    
    // For demo purposes, simulate some memberships
    // In a real app, this would check against a user's actual memberships
    final userMemberships = ['1', '3', '5']; // User is a member of groups 1, 3, and 5
    return userMemberships.contains(groupId);
  }

  static Future<bool> joinGroup(String groupId) async {
    // Simulate API call with minimal delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    // For demo purposes, simulate successful join
    // In a real app, this would make an API call to join the group
    return true;
  }

  static Future<bool> leaveGroup(String groupId) async {
    // Simulate API call with minimal delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    // For demo purposes, simulate successful leave
    // In a real app, this would make an API call to leave the group
    return true;
  }

  static Future<List<BibleStudyGroup>> getMyGroups() async {
    // Simulate API call with minimal delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    // For demo purposes, return groups that the user is a member of
    // In a real app, this would fetch from the user's actual memberships
    final userGroupIds = ['1', '3', '5']; // User is a member of groups 1, 3, and 5
    
    // Create a simple list of groups for demo purposes
    // In a real app, this would come from the group service or database
    return [
      BibleStudyGroup(
        id: '1',
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
        id: '3',
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
        id: '5',
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
    ];
  }

  static Future<List<UserGroupMembership>> getUserMemberships() async {
    // Simulate API call with minimal delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    // For demo purposes, return mock memberships
    // In a real app, this would fetch from the user's actual memberships
    return [
      UserGroupMembership(
        groupId: '1',
        groupName: "Romans Study Group",
        joinedDate: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
        role: 'member',
        notes: 'Great group for deep Bible study',
      ),
      UserGroupMembership(
        groupId: '3',
        groupName: "Young Adults Bible Study",
        joinedDate: DateTime.now().subtract(const Duration(days: 15)),
        isActive: true,
        role: 'co-leader',
        notes: 'Helping lead discussions',
      ),
      UserGroupMembership(
        groupId: '5',
        groupName: "Spanish Bible Study",
        joinedDate: DateTime.now().subtract(const Duration(days: 7)),
        isActive: true,
        role: 'member',
      ),
    ];
  }
}
