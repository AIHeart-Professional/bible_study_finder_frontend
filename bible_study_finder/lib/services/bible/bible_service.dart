import '../../models/bible/bible.dart';
import '../../apis/bible/bible_api.dart';

class BibleService {
  static List<Bible>? _biblesCache;
  static Map<String, List<Book>> _booksCache = {};
  static Map<String, List<Chapter>> _chaptersCache = {};
  static Map<String, String> _chapterContentCache = {};

  static Future<List<Bible>> getBibles() async {
    if (_biblesCache != null) {
      return _biblesCache!;
    }

    try {
      final bibleResponse = await BibleApi.getBiblesApi();

      final englishBibles = _filterEnglishBibles(bibleResponse.data);
      englishBibles.sort((a, b) => a.name.compareTo(b.name));

      _biblesCache = englishBibles;
      return _biblesCache!;
    } catch (e) {
      throw Exception('Error fetching bibles: $e');
    }
  }

  static List<Bible> _filterEnglishBibles(List<Bible> bibles) {
    return bibles.where((bible) {
      final isEnglishByLanguage = bible.language.toLowerCase().contains('english') ||
          bible.language.toLowerCase().contains('eng');

      final popularEnglishIds = getPopularBibleIds();
      final isPopularEnglish = popularEnglishIds.contains(bible.id);

      final popularEnglishNames = getPopularEnglishBibleNames();
      final isPopularEnglishName = popularEnglishNames.any((name) =>
          bible.name.toLowerCase().contains(name.toLowerCase()));

      final englishAbbreviations = [
        'NIV',
        'ESV',
        'NASB',
        'KJV',
        'NLT',
        'CSB',
        'NKJV',
        'MSG',
        'NRSV',
        'RSV',
        'ASV',
        'AMP',
        'CEV',
        'GNV',
        'HCSB',
        'ICB',
        'ISV',
        'LEB',
        'MEV',
        'NABRE',
        'NCV',
        'NET',
        'NIRV',
        'NJB',
        'NLV',
        'TLB',
        'VOICE',
        'WEB',
        'WYC',
        'YLT'
      ];
      final isEnglishByAbbreviation = englishAbbreviations.any((abbr) =>
          bible.abbreviation.toUpperCase().contains(abbr) ||
          bible.name.toUpperCase().contains(abbr));

      return isEnglishByLanguage ||
          isPopularEnglish ||
          isPopularEnglishName ||
          isEnglishByAbbreviation;
    }).toList();
  }

  static Future<List<Book>> getBooks(String bibleId) async {
    if (_booksCache.containsKey(bibleId)) {
      return _booksCache[bibleId]!;
    }

    try {
      final bookResponse = await BibleApi.getBooksApi(bibleId);
      _booksCache[bibleId] = bookResponse.data;
      return _booksCache[bibleId]!;
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  static Future<List<Chapter>> getChapters(String bibleId, String bookId) async {
    final cacheKey = '$bibleId-$bookId';
    if (_chaptersCache.containsKey(cacheKey)) {
      return _chaptersCache[cacheKey]!;
    }

    try {
      final chapterResponse =
          await BibleApi.getChaptersApi(bibleId, bookId);
      _chaptersCache[cacheKey] = chapterResponse.data;
      return _chaptersCache[cacheKey]!;
    } catch (e) {
      throw Exception('Error fetching chapters: $e');
    }
  }

  static Future<String> getChapterContent(
      String bibleId, String chapterId) async {
    final cacheKey = '$bibleId-$chapterId';
    if (_chapterContentCache.containsKey(cacheKey)) {
      return _chapterContentCache[cacheKey]!;
    }

    try {
      final content = await BibleApi.getChapterContentApi(bibleId, chapterId);
      final cleanContent = _cleanHtmlContent(content);
      _chapterContentCache[cacheKey] = cleanContent;
      return cleanContent;
    } catch (e) {
      throw Exception('Error fetching chapter content: $e');
    }
  }

  static Future<List<Verse>> getVerses(String bibleId, String chapterId) async {
    try {
      final verseResponse = await BibleApi.getVersesApi(bibleId, chapterId);
      return verseResponse.data;
    } catch (e) {
      throw Exception('Error fetching verses: $e');
    }
  }

  static String _cleanHtmlContent(String htmlContent) {
    String cleaned = htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();

    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    return cleaned;
  }

  static void clearCache() {
    _biblesCache = null;
    _booksCache.clear();
    _chaptersCache.clear();
    _chapterContentCache.clear();
  }

  static List<String> getPopularBibleIds() {
    return [
      'de4e12af7f28f599-02',
      '06125adad2d5898a-01',
      '65eec8e0b60e656b-01',
      'de4e12af7f28f599-01',
      '592420522e16049f-01',
      'bba9f40183526463-01',
      'bb5d412fea6b5b02-01',
      '65eec8e0b60e656b-02',
      'bb5d412fea6b5b02-02',
      'bba9f40183526463-02',
    ];
  }

  static List<String> getPopularEnglishBibleNames() {
    return [
      'New International Version',
      'English Standard Version',
      'New American Standard Bible',
      'King James Version',
      'New Living Translation',
      'Christian Standard Bible',
      'New King James Version',
      'New Revised Standard Version',
      'Revised Standard Version',
      'American Standard Version',
      'Amplified Bible',
      'Contemporary English Version',
      'Good News Version',
      'Holman Christian Standard Bible',
      'International Children\'s Bible',
      'International Standard Version',
      'Lexham English Bible',
      'Modern English Version',
      'New American Bible Revised Edition',
      'New Century Version',
      'New English Translation',
      'New International Reader\'s Version',
      'New Jerusalem Bible',
      'New Life Version',
      'The Living Bible',
      'The Voice',
      'World English Bible',
      'Wycliffe Bible',
      'Young\'s Literal Translation',
    ];
  }

  static Future<Bible?> getBibleById(String bibleId) async {
    try {
      final bibles = await getBibles();
      return bibles.firstWhere(
        (bible) => bible.id == bibleId,
        orElse: () => bibles.first,
      );
    } catch (e) {
      return null;
    }
  }
}

