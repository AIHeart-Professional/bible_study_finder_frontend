import '../../models/bible/bible.dart';
import '../../apis/bible/bible_api.dart';
import '../../core/logging/logger.dart';

class BibleService {
  static final _logger = getLogger('BibleService');
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
      final sortedBibles = _sortBiblesByName(englishBibles);
      _cacheBibles(sortedBibles);
      return sortedBibles;
    } catch (e) {
      throw Exception('Error fetching bibles: $e');
    }
  }

  static void _cacheBibles(List<Bible> bibles) {
    _biblesCache = bibles;
  }

  static List<Bible> _sortBiblesByName(List<Bible> bibles) {
    final sorted = List<Bible>.from(bibles);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  static List<Bible> _filterEnglishBibles(List<Bible> bibles) {
    return bibles.where((bible) => _isEnglishBible(bible)).toList();
  }

  static bool _isEnglishBible(Bible bible) {
    return _isEnglishByLanguage(bible) ||
        _isPopularEnglishBible(bible) ||
        _isEnglishByName(bible) ||
        _isEnglishByAbbreviation(bible);
  }

  static bool _isEnglishByLanguage(Bible bible) {
    final language = bible.language.toLowerCase();
    return language.contains('english') || language.contains('eng');
  }

  static bool _isPopularEnglishBible(Bible bible) {
    final popularIds = getPopularBibleIds();
    return popularIds.contains(bible.id);
  }

  static bool _isEnglishByName(Bible bible) {
    final popularNames = getPopularEnglishBibleNames();
    final bibleName = bible.name.toLowerCase();
    return popularNames.any((name) => bibleName.contains(name.toLowerCase()));
  }

  static bool _isEnglishByAbbreviation(Bible bible) {
    final abbreviations = _getEnglishAbbreviations();
    final bibleAbbr = bible.abbreviation.toUpperCase();
    final bibleName = bible.name.toUpperCase();
    return abbreviations.any((abbr) =>
        bibleAbbr.contains(abbr) || bibleName.contains(abbr));
  }

  static List<String> _getEnglishAbbreviations() {
    return [
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
  }

  static Future<List<Book>> getBooks(String bibleId) async {
    if (_booksCache.containsKey(bibleId)) {
      return _booksCache[bibleId]!;
    }

    try {
      final bookResponse = await BibleApi.getBooksApi(bibleId);
      _cacheBooks(bibleId, bookResponse.data);
      return _booksCache[bibleId]!;
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  static void _cacheBooks(String bibleId, List<Book> books) {
    _booksCache[bibleId] = books;
  }

  static Future<List<Chapter>> getChapters(String bibleId, String bookId) async {
    final cacheKey = _buildChapterCacheKey(bibleId, bookId);
    if (_chaptersCache.containsKey(cacheKey)) {
      return _chaptersCache[cacheKey]!;
    }

    try {
      final chapterResponse = await BibleApi.getChaptersApi(bibleId, bookId);
      _cacheChapters(cacheKey, chapterResponse.data);
      return _chaptersCache[cacheKey]!;
    } catch (e) {
      throw Exception('Error fetching chapters: $e');
    }
  }

  static String _buildChapterCacheKey(String bibleId, String bookId) {
    return '$bibleId-$bookId';
  }

  static void _cacheChapters(String cacheKey, List<Chapter> chapters) {
    _chaptersCache[cacheKey] = chapters;
  }

  static Future<String> getChapterContent(
      String bibleId, String chapterId) async {
    final cacheKey = _buildContentCacheKey(bibleId, chapterId);
    if (_chapterContentCache.containsKey(cacheKey)) {
      return _chapterContentCache[cacheKey]!;
    }

    try {
      final content = await BibleApi.getChapterContentApi(bibleId, chapterId);
      final cleanContent = _cleanHtmlContent(content);
      _cacheChapterContent(cacheKey, cleanContent);
      return cleanContent;
    } catch (e) {
      throw Exception('Error fetching chapter content: $e');
    }
  }

  static String _buildContentCacheKey(String bibleId, String chapterId) {
    return '$bibleId-$chapterId';
  }

  static void _cacheChapterContent(String cacheKey, String content) {
    _chapterContentCache[cacheKey] = content;
  }

  static String _cleanHtmlContent(String htmlContent) {
    final withoutTags = _removeHtmlTags(htmlContent);
    final withoutEntities = _decodeHtmlEntities(withoutTags);
    return _normalizeWhitespace(withoutEntities);
  }

  static String _removeHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  static String _decodeHtmlEntities(String html) {
    return html
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  static String _normalizeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ');
  }

  static Future<List<Verse>> getVerses(String bibleId, String chapterId) async {
    _logger.debug('getVerses called with bibleId=$bibleId, chapterId=$chapterId');
    
    try {
      _logger.debug('Fetching verses from API');
      final verseResponse = await BibleApi.getVersesApi(bibleId, chapterId);
      
      _logger.info('Successfully fetched ${verseResponse.data.length} verses');
      _logger.debug('First verse: ${verseResponse.data.isNotEmpty ? verseResponse.data.first.id : 'none'}');
      
      return verseResponse.data;
    } catch (e, stackTrace) {
      _logger.error('Error fetching verses', error: e, stackTrace: stackTrace);
      throw Exception('Error fetching verses: $e');
    }
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
      return _findBibleById(bibles, bibleId);
    } catch (e) {
      return null;
    }
  }

  static Bible? _findBibleById(List<Bible> bibles, String bibleId) {
    return bibles.firstWhere(
      (bible) => bible.id == bibleId,
      orElse: () => bibles.first,
    );
  }
}
