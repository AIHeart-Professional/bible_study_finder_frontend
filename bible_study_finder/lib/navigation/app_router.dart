import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/groups/search_page.dart';
import '../pages/churches/churches_page.dart';
import '../pages/bible/bible_page.dart';
import '../pages/study/study_page.dart';
import '../pages/home/about_page.dart';

class AppRouter {
  static const String home = '/';
  static const String groups = '/groups';
  static const String churches = '/churches';
  static const String bible = '/bible';
  static const String study = '/study';
  static const String about = '/about';

  static const List<String> _titles = [
    'Bible Study Finder',
    'Find Groups',
    'Find Churches',
    'Read Bible',
    'Study Plans',
    'About',
  ];

  static const List<String> _descriptions = [
    'Connect, Study, Grow Together',
    'Discover Bible study groups near you',
    'Explore churches in your area',
    'Read God\'s Word in multiple versions',
    'Guided Bible study resources',
    'Learn more about our mission',
  ];

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.group_outlined,
    Icons.church_outlined,
    Icons.menu_book_outlined,
    Icons.school_outlined,
    Icons.info_outline,
  ];

  static const List<IconData> _activeIcons = [
    Icons.home,
    Icons.group,
    Icons.church,
    Icons.menu_book,
    Icons.school,
    Icons.info,
  ];

  static const List<String> _labels = [
    'Home',
    'Groups',
    'Churches',
    'Bible',
    'Study',
    'About',
  ];

  static List<Widget> get pages => [
    const HomePage(),
    const SearchPage(),
    const ChurchesPage(),
    const BiblePage(),
    const StudyPage(),
    const AboutPage(),
  ];

  static String getTitle(int index) => _titles[index];
  static String getDescription(int index) => _descriptions[index];
  static IconData getIcon(int index) => _icons[index];
  static IconData getActiveIcon(int index) => _activeIcons[index];
  static String getLabel(int index) => _labels[index];

  static BottomNavigationBarItem getBottomNavItem(int index) {
    return BottomNavigationBarItem(
      icon: Icon(_icons[index]),
      activeIcon: Icon(_activeIcons[index]),
      label: _labels[index],
    );
  }
}
