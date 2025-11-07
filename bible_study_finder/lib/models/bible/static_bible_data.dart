import 'bible.dart';

class StaticBibleData {
  // Old Testament Books with their chapter counts
  static final List<Book> oldTestamentBooks = [
    Book(id: 'GEN', name: 'Genesis', testament: 'OT', chapterCount: 50),
    Book(id: 'EXO', name: 'Exodus', testament: 'OT', chapterCount: 40),
    Book(id: 'LEV', name: 'Leviticus', testament: 'OT', chapterCount: 27),
    Book(id: 'NUM', name: 'Numbers', testament: 'OT', chapterCount: 36),
    Book(id: 'DEU', name: 'Deuteronomy', testament: 'OT', chapterCount: 34),
    Book(id: 'JOS', name: 'Joshua', testament: 'OT', chapterCount: 24),
    Book(id: 'JDG', name: 'Judges', testament: 'OT', chapterCount: 21),
    Book(id: 'RUT', name: 'Ruth', testament: 'OT', chapterCount: 4),
    Book(id: '1SA', name: '1 Samuel', testament: 'OT', chapterCount: 31),
    Book(id: '2SA', name: '2 Samuel', testament: 'OT', chapterCount: 24),
    Book(id: '1KI', name: '1 Kings', testament: 'OT', chapterCount: 22),
    Book(id: '2KI', name: '2 Kings', testament: 'OT', chapterCount: 25),
    Book(id: '1CH', name: '1 Chronicles', testament: 'OT', chapterCount: 29),
    Book(id: '2CH', name: '2 Chronicles', testament: 'OT', chapterCount: 36),
    Book(id: 'EZR', name: 'Ezra', testament: 'OT', chapterCount: 10),
    Book(id: 'NEH', name: 'Nehemiah', testament: 'OT', chapterCount: 13),
    Book(id: 'EST', name: 'Esther', testament: 'OT', chapterCount: 10),
    Book(id: 'JOB', name: 'Job', testament: 'OT', chapterCount: 42),
    Book(id: 'PSA', name: 'Psalms', testament: 'OT', chapterCount: 150),
    Book(id: 'PRO', name: 'Proverbs', testament: 'OT', chapterCount: 31),
    Book(id: 'ECC', name: 'Ecclesiastes', testament: 'OT', chapterCount: 12),
    Book(id: 'SNG', name: 'Song of Songs', testament: 'OT', chapterCount: 8),
    Book(id: 'ISA', name: 'Isaiah', testament: 'OT', chapterCount: 66),
    Book(id: 'JER', name: 'Jeremiah', testament: 'OT', chapterCount: 52),
    Book(id: 'LAM', name: 'Lamentations', testament: 'OT', chapterCount: 5),
    Book(id: 'EZK', name: 'Ezekiel', testament: 'OT', chapterCount: 48),
    Book(id: 'DAN', name: 'Daniel', testament: 'OT', chapterCount: 12),
    Book(id: 'HOS', name: 'Hosea', testament: 'OT', chapterCount: 14),
    Book(id: 'JOL', name: 'Joel', testament: 'OT', chapterCount: 3),
    Book(id: 'AMO', name: 'Amos', testament: 'OT', chapterCount: 9),
    Book(id: 'OBA', name: 'Obadiah', testament: 'OT', chapterCount: 1),
    Book(id: 'JON', name: 'Jonah', testament: 'OT', chapterCount: 4),
    Book(id: 'MIC', name: 'Micah', testament: 'OT', chapterCount: 7),
    Book(id: 'NAH', name: 'Nahum', testament: 'OT', chapterCount: 3),
    Book(id: 'HAB', name: 'Habakkuk', testament: 'OT', chapterCount: 3),
    Book(id: 'ZEP', name: 'Zephaniah', testament: 'OT', chapterCount: 3),
    Book(id: 'HAG', name: 'Haggai', testament: 'OT', chapterCount: 2),
    Book(id: 'ZEC', name: 'Zechariah', testament: 'OT', chapterCount: 14),
    Book(id: 'MAL', name: 'Malachi', testament: 'OT', chapterCount: 4),
  ];

  // New Testament Books with their chapter counts
  static final List<Book> newTestamentBooks = [
    Book(id: 'MAT', name: 'Matthew', testament: 'NT', chapterCount: 28),
    Book(id: 'MRK', name: 'Mark', testament: 'NT', chapterCount: 16),
    Book(id: 'LUK', name: 'Luke', testament: 'NT', chapterCount: 24),
    Book(id: 'JHN', name: 'John', testament: 'NT', chapterCount: 21),
    Book(id: 'ACT', name: 'Acts', testament: 'NT', chapterCount: 28),
    Book(id: 'ROM', name: 'Romans', testament: 'NT', chapterCount: 16),
    Book(id: '1CO', name: '1 Corinthians', testament: 'NT', chapterCount: 16),
    Book(id: '2CO', name: '2 Corinthians', testament: 'NT', chapterCount: 13),
    Book(id: 'GAL', name: 'Galatians', testament: 'NT', chapterCount: 6),
    Book(id: 'EPH', name: 'Ephesians', testament: 'NT', chapterCount: 6),
    Book(id: 'PHP', name: 'Philippians', testament: 'NT', chapterCount: 4),
    Book(id: 'COL', name: 'Colossians', testament: 'NT', chapterCount: 4),
    Book(id: '1TH', name: '1 Thessalonians', testament: 'NT', chapterCount: 5),
    Book(id: '2TH', name: '2 Thessalonians', testament: 'NT', chapterCount: 3),
    Book(id: '1TI', name: '1 Timothy', testament: 'NT', chapterCount: 6),
    Book(id: '2TI', name: '2 Timothy', testament: 'NT', chapterCount: 4),
    Book(id: 'TIT', name: 'Titus', testament: 'NT', chapterCount: 3),
    Book(id: 'PHM', name: 'Philemon', testament: 'NT', chapterCount: 1),
    Book(id: 'HEB', name: 'Hebrews', testament: 'NT', chapterCount: 13),
    Book(id: 'JAS', name: 'James', testament: 'NT', chapterCount: 5),
    Book(id: '1PE', name: '1 Peter', testament: 'NT', chapterCount: 5),
    Book(id: '2PE', name: '2 Peter', testament: 'NT', chapterCount: 3),
    Book(id: '1JN', name: '1 John', testament: 'NT', chapterCount: 5),
    Book(id: '2JN', name: '2 John', testament: 'NT', chapterCount: 1),
    Book(id: '3JN', name: '3 John', testament: 'NT', chapterCount: 1),
    Book(id: 'JUD', name: 'Jude', testament: 'NT', chapterCount: 1),
    Book(id: 'REV', name: 'Revelation', testament: 'NT', chapterCount: 22),
  ];

  // Get all books
  static List<Book> get allBooks => [...oldTestamentBooks, ...newTestamentBooks];

  // Get books by testament
  static List<Book> getBooksByTestament(String testament) {
    return testament == 'OT' ? oldTestamentBooks : newTestamentBooks;
  }

  // Get a specific book by ID
  static Book? getBookById(String bookId) {
    return allBooks.firstWhere(
      (book) => book.id == bookId,
      orElse: () => allBooks.first,
    );
  }

  // Generate chapters for a book
  static List<Chapter> generateChaptersForBook(String bookId) {
    final book = getBookById(bookId);
    if (book == null || book.chapterCount == null) return [];

    return List.generate(book.chapterCount!, (index) {
      final chapterNumber = index + 1;
      return Chapter(
        id: '$bookId.$chapterNumber',
        number: chapterNumber.toString(),
        bookId: bookId,
      );
    });
  }

  // Get chapter count for a book
  static int getChapterCount(String bookId) {
    final book = getBookById(bookId);
    return book?.chapterCount ?? 0;
  }

  // Check if a book exists
  static bool bookExists(String bookId) {
    return allBooks.any((book) => book.id == bookId);
  }

  // Get book name by ID
  static String getBookName(String bookId) {
    final book = getBookById(bookId);
    return book?.name ?? 'Unknown Book';
  }

  // Get testament by book ID
  static String getTestament(String bookId) {
    final book = getBookById(bookId);
    return book?.testament ?? 'OT';
  }
}
