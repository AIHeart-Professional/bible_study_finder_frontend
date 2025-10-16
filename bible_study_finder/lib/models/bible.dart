class Bible {
  final String id;
  final String name;
  final String abbreviation;
  final String language;
  final String? description;

  Bible({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.language,
    this.description,
  });

  factory Bible.fromJson(Map<String, dynamic> json) {
    return Bible(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      language: json['language']?['name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'language': language,
      'description': description,
    };
  }
}

class Book {
  final String id;
  final String name;
  final String testament;
  final int? chapterCount;

  Book({
    required this.id,
    required this.name,
    required this.testament,
    this.chapterCount,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final bookId = json['id'] ?? '';
    final bookName = json['name'] ?? '';
    
    // Determine testament based on book ID or name
    String testament = _determineTestament(bookId, bookName);
    
    return Book(
      id: bookId,
      name: bookName,
      testament: testament,
      chapterCount: json['chapterCount'],
    );
  }

  static String _determineTestament(String bookId, String bookName) {
    // New Testament books
    final newTestamentIds = [
      'MAT', 'MRK', 'LUK', 'JHN', 'ACT', 'ROM', '1CO', '2CO', 'GAL', 'EPH',
      'PHP', 'COL', '1TH', '2TH', '1TI', '2TI', 'TIT', 'PHM', 'HEB', 'JAS',
      '1PE', '2PE', '1JN', '2JN', '3JN', 'JUD', 'REV'
    ];
    
    final newTestamentNames = [
      'Matthew', 'Mark', 'Luke', 'John', 'Acts', 'Romans', '1 Corinthians', 
      '2 Corinthians', 'Galatians', 'Ephesians', 'Philippians', 'Colossians',
      '1 Thessalonians', '2 Thessalonians', '1 Timothy', '2 Timothy', 'Titus',
      'Philemon', 'Hebrews', 'James', '1 Peter', '2 Peter', '1 John', '2 John',
      '3 John', 'Jude', 'Revelation'
    ];
    
    if (newTestamentIds.contains(bookId) || newTestamentNames.contains(bookName)) {
      return 'NT';
    } else {
      return 'OT';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'testament': testament,
      'chapterCount': chapterCount,
    };
  }

  bool get isOldTestament => testament == 'OT';
  bool get isNewTestament => testament == 'NT';
}

class Chapter {
  final String id;
  final String number;
  final String bookId;
  final String? content;

  Chapter({
    required this.id,
    required this.number,
    required this.bookId,
    this.content,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? '',
      number: json['number'] ?? '',
      bookId: json['bookId'] ?? '',
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'bookId': bookId,
      'content': content,
    };
  }

  int get chapterNumber => int.tryParse(number) ?? 0;
}

class Verse {
  final String id;
  final String number;
  final String text;
  final String chapterId;

  Verse({
    required this.id,
    required this.number,
    required this.text,
    required this.chapterId,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] ?? '',
      number: json['number'] ?? '',
      text: json['text'] ?? '',
      chapterId: json['chapterId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'text': text,
      'chapterId': chapterId,
    };
  }

  int get verseNumber => int.tryParse(number) ?? 0;
}

class BibleResponse<T> {
  final List<T> data;
  final String? next;

  BibleResponse({
    required this.data,
    this.next,
  });

  factory BibleResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return BibleResponse<T>(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList() ?? [],
      next: json['next'],
    );
  }
}

