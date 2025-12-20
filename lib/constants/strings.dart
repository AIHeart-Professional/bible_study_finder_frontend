/// Centralized string constants for the Bible Study Finder app.
/// 
/// All UI strings should be defined here for:
/// - Easy maintenance
/// - Consistent wording
/// - Future internationalization support
/// - Quick updates
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // App Info
  static const String appName = 'Bible Study Finder';
  static const String appTitle = 'Bible Study Finder';

  // Page Titles
  static const String homeTitle = 'Home';
  static const String groupsTitle = 'Groups';
  static const String myGroupsTitle = 'My Groups';
  static const String findGroupsTitle = 'Find Groups';
  static const String createGroupTitle = 'Create Group';
  static const String groupDetailsTitle = 'Group Details';
  static const String churchesTitle = 'Churches';
  static const String bibleTitle = 'Bible';
  static const String studyTitle = 'Study';
  static const String aboutTitle = 'About';

  // Page Descriptions
  static const String homeDescription = 'Welcome to your Bible study hub';
  static const String groupsDescription = 'Discover Bible study groups near you';
  static const String churchesDescription = 'Find churches in your area';
  static const String bibleDescription = 'Read and study the Bible';
  static const String studyDescription = 'Your personal study plans';

  // Group-related strings
  static const String myBibleStudyGroups = 'My Bible Study Groups';
  static const String groupsParticipatingIn = 'Groups you\'re currently participating in';
  static const String yourGroups = 'Your Groups';
  static const String searchGroups = 'Search Groups';
  static const String createNewGroup = 'Create New Group';
  static const String joinGroup = 'Join Group';
  static const String leaveGroup = 'Leave Group';
  static const String groupDetails = 'Details';
  static const String groupMembers = 'Members';
  static const String groupChats = 'Chats';
  static const String groupResources = 'Resources';
  static const String groupInfo = 'Info';
  static const String groupAdmin = 'Admin';

  // Button Labels
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String apply = 'Apply';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String close = 'Close';
  static const String confirm = 'Confirm';
  static const String submit = 'Submit';
  static const String create = 'Create';
  static const String update = 'Update';
  static const String retry = 'Retry';
  static const String continueLabel = 'Continue';
  static const String start = 'Start';
  static const String readMore = 'Read More';
  static const String viewDetails = 'View Details';
  static const String applyFilters = 'Apply Filters';
  static const String adjustFilters = 'Adjust Filters';

  // Auth strings
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String createAccount = 'Create Account';
  static const String loginCreateAccount = 'Login / Create Account';
  static const String logoutConfirmation = 'Are you sure you want to logout?';
  static const String successfullyLoggedOut = 'Successfully logged out';

  // Loading states
  static const String loading = 'Loading...';
  static const String loadingGroups = 'Loading groups...';
  static const String loadingChurches = 'Searching for churches...';
  static const String loadingBibles = 'Loading Bibles...';
  static const String loadingBooks = 'Loading books...';
  static const String loadingChapters = 'Loading chapters...';
  static const String loadingVerses = 'Loading verses...';
  static const String loadingGroupDetails = 'Loading group details...';

  // Empty states
  static const String noGroupsFound = 'No groups found';
  static const String noChurchesFound = 'No churches found';
  static const String tryAdjustingSearch = 'Try adjusting your search criteria';
  static const String tryAdjustingLocation = 'Try adjusting your search criteria or location';
  static const String selectBible = 'Select a Bible to begin reading';
  static const String selectBook = 'Select a book to begin reading';
  static const String selectChapter = 'Select a chapter to begin reading';
  static const String noVersesFound = 'No verses found for this chapter';
  static const String groupNotFound = 'Group not found';

  // Error messages
  static const String error = 'Error';
  static const String errorLoadingGroups = 'Error loading groups';
  static const String errorSearchingGroups = 'Error searching groups';
  static const String errorSearchingChurches = 'Error searching churches';
  static const String errorLoadingGroup = 'Error Loading Group';
  static const String errorCreatingGroup = 'Error creating group';
  static const String errorJoiningGroup = 'Error joining group';
  static const String errorLeavingGroup = 'Error leaving group';
  static const String unknownError = 'Unknown error';

  // Success messages
  static const String groupCreatedSuccessfully = 'Group created successfully!';
  static const String joinRequestSent = 'Join request sent! Waiting for approval.';
  static const String successfullyLeftGroup = 'Successfully left';

  // Form labels
  static const String groupName = 'Group Name';
  static const String description = 'Description';
  static const String location = 'Location';
  static const String meetingDay = 'Meeting Day';
  static const String meetingTime = 'Meeting Time';
  static const String studyType = 'Study Type';
  static const String language = 'Language';
  static const String ageGroup = 'Age Group';
  static const String maxGroupSize = 'Maximum Group Size';
  static const String maxDistance = 'Maximum Distance';
  static const String denomination = 'Denomination';

  // Placeholders
  static const String searchHint = 'Search groups...';
  static const String locationHint = 'Enter your location...';
  static const String locationOptional = 'Location (optional)';
  static const String typeMessageHint = 'Type your message...';
  static const String anyDenomination = 'Any Denomination';
  static const String anyStudyType = 'Any Study Type';
  static const String anyDay = 'Any Day';
  static const String anyLanguage = 'Any Language';
  static const String anyAgeGroup = 'Any Age Group';

  // Filter options
  static const String filters = 'Filters';
  static const String quickFilters = 'Quick Filters';
  static const String filterGroups = 'Filter Groups';
  static const String filterChurches = 'Filter Churches';
  static const String onlineGroups = 'Online Groups';
  static const String inPersonGroups = 'In-Person Groups';
  static const String childcareAvailable = 'Childcare Available';
  static const String beginnersWelcome = 'Beginners Welcome';

  // Study-related
  static const String dailyVerse = 'Daily Verse';
  static const String studyPlans = 'Study Plans';
  static const String quickStudyTools = 'Quick Study Tools';
  static const String studyTipOfTheDay = 'Study Tip of the Day';
  static const String searchScripture = 'Search Scripture';
  static const String bookmarks = 'Bookmarks';
  static const String notes = 'Notes';
  static const String readingHistory = 'Reading History';

  // Tooltips
  static const String switchThemeTooltip = 'Switch theme';
  static const String logoutTooltip = 'Logout';
  static const String loginTooltip = 'Login / Create Account';
  static const String quickFiltersTooltip = 'Quick Filters';
  static const String sendMessageTooltip = 'Send message';

  // Bible-related
  static const String bibleVersion = 'Bible Version';
  static const String book = 'Book';
  static const String chapter = 'Chapter';
  static const String selectReading = 'Select Reading';

  // Misc
  static const String member = 'MEMBER';
  static const String joinedToday = 'Joined today';
  static const String searchResults = 'Search Results';
  static const String groupsFoundSuffix = 'groups found';
  static const String churchesFoundSuffix = 'churches found';
  static const String startConversation = 'Start a conversation';
  static const String askAnything = 'Ask me anything or use the chatbox to navigate the app';
}















