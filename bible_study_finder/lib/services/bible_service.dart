import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible/bible.dart';
import '../utils/app_config.dart';

class BibleService {
  static const String _baseUrl = AppConfig.bibleApiUrl;
  static const String _apiKey = AppConfig.bibleApiKey;
  
  // Cache for frequently accessed data
  static List<Bible>? _biblesCache;
  static Map<String, List<Book>> _booksCache = {};
  static Map<String, List<Chapter>> _chaptersCache = {};
  static Map<String, String> _chapterContentCache = {};

  /// Get all available English Bible versions
  static Future<List<Bible>> getBibles() async {
    if (_biblesCache != null) {
      return _biblesCache!;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bibles'),
        headers: {
          'api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final bibleResponse = BibleResponse<Bible>.fromJson(
          jsonData,
          (json) => Bible.fromJson(json),
        );
        
        // Filter for English Bibles only
        final englishBibles = bibleResponse.data.where((bible) {
          // Check by language
          final isEnglishByLanguage = bible.language.toLowerCase().contains('english') || 
                                     bible.language.toLowerCase().contains('eng');
          
          // Check by known popular English Bible IDs
          final popularEnglishIds = getPopularBibleIds();
          final isPopularEnglish = popularEnglishIds.contains(bible.id);
          
          // Check by popular English Bible names
          final popularEnglishNames = getPopularEnglishBibleNames();
          final isPopularEnglishName = popularEnglishNames.any((name) => 
            bible.name.toLowerCase().contains(name.toLowerCase()));
          
          // Check by abbreviation (common English versions)
          final englishAbbreviations = ['NIV', 'ESV', 'NASB', 'KJV', 'NLT', 'CSB', 'NKJV', 'MSG', 'NRSV', 'RSV', 'ASV', 'AMP', 'CEV', 'GNV', 'HCSB', 'ICB', 'ISV', 'LEB', 'MEV', 'NABRE', 'NCV', 'NET', 'NIRV', 'NJB', 'NLV', 'TLB', 'VOICE', 'WEB', 'WYC', 'YLT'];
          final isEnglishByAbbreviation = englishAbbreviations.any((abbr) => 
            bible.abbreviation.toUpperCase().contains(abbr) || 
            bible.name.toUpperCase().contains(abbr));
          
          return isEnglishByLanguage || isPopularEnglish || isPopularEnglishName || isEnglishByAbbreviation;
        }).toList();
        
        // Sort by name for better user experience
        englishBibles.sort((a, b) => a.name.compareTo(b.name));
        
        _biblesCache = englishBibles;
        return _biblesCache!;
      } else {
        throw Exception('Failed to load bibles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching bibles: $e');
    }
  }

  /// Get all books for a specific Bible version
  static Future<List<Book>> getBooks(String bibleId) async {
    if (_booksCache.containsKey(bibleId)) {
      return _booksCache[bibleId]!;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bibles/$bibleId/books'),
        headers: {
          'api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final bookResponse = BibleResponse<Book>.fromJson(
          jsonData,
          (json) => Book.fromJson(json),
        );
        _booksCache[bibleId] = bookResponse.data;
        return _booksCache[bibleId]!;
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  /// Get all chapters for a specific book
  static Future<List<Chapter>> getChapters(String bibleId, String bookId) async {
    final cacheKey = '$bibleId-$bookId';
    if (_chaptersCache.containsKey(cacheKey)) {
      return _chaptersCache[cacheKey]!;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bibles/$bibleId/books/$bookId/chapters'),
        headers: {
          'api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final chapterResponse = BibleResponse<Chapter>.fromJson(
          jsonData,
          (json) => Chapter.fromJson(json),
        );
        _chaptersCache[cacheKey] = chapterResponse.data;
        return _chaptersCache[cacheKey]!;
      } else {
        throw Exception('Failed to load chapters: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching chapters: $e');
    }
  }


  /// Get the content of a specific chapter
  static Future<String> getChapterContent(String bibleId, String chapterId) async {
    final cacheKey = '$bibleId-$chapterId';
    if (_chapterContentCache.containsKey(cacheKey)) {
      return _chapterContentCache[cacheKey]!;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bibles/$bibleId/chapters/$chapterId'),
        headers: {
          'api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final content = jsonData['data']['content'] as String? ?? '';
        
        // Clean up HTML tags and format the content
        final cleanContent = _cleanHtmlContent(content);
        _chapterContentCache[cacheKey] = cleanContent;
        return cleanContent;
      } else {
        throw Exception('Failed to load chapter content: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching chapter content: $e');
    }
  }


  /// Get verses for a specific chapter
  static Future<List<Verse>> getVerses(String bibleId, String chapterId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bibles/$bibleId/chapters/$chapterId/verses'),
        headers: {
          'api-key': _apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final verseResponse = BibleResponse<Verse>.fromJson(
          jsonData,
          (json) => Verse.fromJson(json),
        );
        return verseResponse.data;
      } else {
        throw Exception('Failed to load verses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching verses: $e');
    }
  }

  /// Clean HTML content and format it for display
  static String _cleanHtmlContent(String htmlContent) {
    // Remove HTML tags and decode entities
    String cleaned = htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&nbsp;', ' ') // Replace non-breaking spaces
        .replaceAll('&amp;', '&') // Replace ampersands
        .replaceAll('&lt;', '<') // Replace less than
        .replaceAll('&gt;', '>') // Replace greater than
        .replaceAll('&quot;', '"') // Replace quotes
        .replaceAll('&#39;', "'") // Replace apostrophes
        .trim();

    // Clean up extra whitespace
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    
    return cleaned;
  }

  /// Clear all caches (useful for testing or when data needs to be refreshed)
  static void clearCache() {
    _biblesCache = null;
    _booksCache.clear();
    _chaptersCache.clear();
    _chapterContentCache.clear();
  }

  /// Get popular English Bible versions for quick selection
  static List<String> getPopularBibleIds() {
    return [
      'de4e12af7f28f599-02', // NIV
      '06125adad2d5898a-01', // ESV
      '65eec8e0b60e656b-01', // NASB
      'de4e12af7f28f599-01', // KJV
      '592420522e16049f-01', // NLT
      'bba9f40183526463-01', // CSB
      'bb5d412fea6b5b02-01', // NKJV
      '65eec8e0b60e656b-02', // NASB 2020
      'bb5d412fea6b5b02-02', // NKJV
      'bba9f40183526463-02', // CSB
    ];
  }

  /// Get a curated list of popular English Bible versions
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

  /// Get Bible by popular ID
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

