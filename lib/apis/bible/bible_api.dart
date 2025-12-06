import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/bible/bible.dart';
import '../../core/config/app_config.dart';

class BibleApi {
  static const String _baseUrl = AppConfig.bibleApiUrl;
  static const String _apiKey = AppConfig.bibleApiKey;

  static Future<BibleResponse<Bible>> getBiblesApi() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bibles'),
      headers: {
        'api-key': _apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BibleResponse<Bible>.fromJson(
        jsonData,
        (json) => Bible.fromJson(json),
      );
    } else {
      throw Exception('Failed to load bibles: ${response.statusCode}');
    }
  }

  static Future<BibleResponse<Book>> getBooksApi(String bibleId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/books'),
      headers: {
        'api-key': _apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BibleResponse<Book>.fromJson(
        jsonData,
        (json) => Book.fromJson(json),
      );
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  static Future<BibleResponse<Chapter>> getChaptersApi(
      String bibleId, String bookId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/books/$bookId/chapters'),
      headers: {
        'api-key': _apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BibleResponse<Chapter>.fromJson(
        jsonData,
        (json) => Chapter.fromJson(json),
      );
    } else {
      throw Exception('Failed to load chapters: ${response.statusCode}');
    }
  }

  static Future<String> getChapterContentApi(
      String bibleId, String chapterId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/chapters/$chapterId'),
      headers: {
        'api-key': _apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data']['content'] as String? ?? '';
    } else {
      throw Exception(
          'Failed to load chapter content: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<BibleResponse<Verse>> getVersesApi(
      String bibleId, String chapterId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bibles/$bibleId/chapters/$chapterId/verses'),
      headers: {
        'api-key': _apiKey,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BibleResponse<Verse>.fromJson(
        jsonData,
        (json) => Verse.fromJson(json),
      );
    } else {
      throw Exception('Failed to load verses: ${response.statusCode}');
    }
  }
}

