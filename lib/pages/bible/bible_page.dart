import 'package:flutter/material.dart';
import '../../models/bible/bible.dart';
import '../../services/bible/bible_service.dart';
import '../../core/utils/platform_helper.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  List<Bible> _bibles = [];
  List<Book> _books = [];
  List<Chapter> _chapters = [];
  List<Verse> _verses = [];
  
  String? _selectedBibleId;
  String? _selectedBookId;
  String? _selectedChapterId;
  
  bool _isLoadingBibles = false;
  bool _isLoadingBooks = false;
  bool _isLoadingChapters = false;
  bool _isLoadingVerses = false;
  
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBibles();
  }

  Future<void> _loadBibles() async {
    setState(() {
      _isLoadingBibles = true;
      _error = null;
    });

    try {
      final bibles = await BibleService.getBibles();
      setState(() {
        _bibles = bibles;
        _isLoadingBibles = false;
        if (bibles.isNotEmpty) {
          _selectedBibleId = bibles.first.id;
          _loadBooks();
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load Bibles: $e';
        _isLoadingBibles = false;
      });
    }
  }

  Future<void> _loadBooks() async {
    if (_selectedBibleId == null) return;

    setState(() {
      _isLoadingBooks = true;
    });

    try {
      final books = await BibleService.getBooks(_selectedBibleId!);
      setState(() {
        _books = books;
        _isLoadingBooks = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBooks = false;
      });
    }
  }

  Future<void> _loadChapters() async {
    if (_selectedBibleId == null || _selectedBookId == null) return;

    setState(() {
      _isLoadingChapters = true;
    });

    try {
      final chapters = await BibleService.getChapters(_selectedBibleId!, _selectedBookId!);
      setState(() {
        _chapters = chapters;
        _isLoadingChapters = false;
        if (chapters.isNotEmpty) {
          _selectedChapterId = chapters.first.id;
          _loadVerses();
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingChapters = false;
      });
    }
  }

  Future<void> _loadVerses() async {
    if (_selectedBibleId == null || _selectedChapterId == null) return;

    setState(() {
      _isLoadingVerses = true;
    });

    try {
      final verses = await BibleService.getVerses(_selectedBibleId!, _selectedChapterId!);
      setState(() {
        _verses = verses;
        _isLoadingVerses = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingVerses = false;
      });
    }
  }

  void _onBibleChanged(String? bibleId) {
    setState(() {
      _selectedBibleId = bibleId;
      _selectedBookId = null;
      _selectedChapterId = null;
      _books.clear();
      _chapters.clear();
      _verses.clear();
    });
    if (bibleId != null) {
      _loadBooks();
    }
  }

  void _onBookChanged(String? bookId) {
    setState(() {
      _selectedBookId = bookId;
      _selectedChapterId = null;
      _chapters.clear();
      _verses.clear();
    });
    if (bookId != null) {
      _loadChapters();
    }
  }

  void _onChapterChanged(String? chapterId) {
    setState(() {
      _selectedChapterId = chapterId;
      _verses.clear();
    });
    if (chapterId != null) {
      _loadVerses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldUseWebLayout = PlatformHelper.shouldUseWebLayout(context);
    
    if (shouldUseWebLayout) {
      return _buildWebLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildWebLayout(BuildContext context) {
    return Row(
      children: [
        // Left sidebar for Bible, Book, Chapter selection
        Container(
          width: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: PlatformHelper.getResponsivePadding(context),
                child: Text(
                  'Select Reading',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: PlatformHelper.getResponsivePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bible Selection
                      Text(
                        'Bible Version',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedBibleId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _bibles.map((bible) {
                          return DropdownMenuItem<String>(
                            value: bible.id,
                            child: Text(bible.name),
                          );
                        }).toList(),
                        onChanged: _onBibleChanged,
                      ),
                      const SizedBox(height: 16),
                      
                      // Book Selection
                      Text(
                        'Book',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedBookId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _books.map((book) {
                          return DropdownMenuItem<String>(
                            value: book.id,
                            child: Text(book.name),
                          );
                        }).toList(),
                        onChanged: _onBookChanged,
                      ),
                      const SizedBox(height: 16),
                      
                      // Chapter Selection
                      Text(
                        'Chapter',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedChapterId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: _chapters.map((chapter) {
                          return DropdownMenuItem<String>(
                            value: chapter.id,
                            child: Text('Chapter ${chapter.number}'),
                          );
                        }).toList(),
                        onChanged: _onChapterChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Right panel for verse reading
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Header with Bible and Book Selection
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Bible Selection
              Row(
                children: [
                  const Icon(Icons.menu_book),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedBibleId,
                      hint: const Text('Select Bible'),
                      isExpanded: true,
                      items: _bibles.map((bible) {
                        return DropdownMenuItem<String>(
                          value: bible.id,
                          child: Text(bible.name),
                        );
                      }).toList(),
                      onChanged: _onBibleChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Book Selection
              Row(
                children: [
                  const Icon(Icons.library_books),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedBookId,
                      hint: const Text('Select Book'),
                      isExpanded: true,
                      items: _books.map((book) {
                        return DropdownMenuItem<String>(
                          value: book.id,
                          child: Text(book.name),
                        );
                      }).toList(),
                      onChanged: _onBookChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Chapter Selection
              Row(
                children: [
                  const Icon(Icons.list),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedChapterId,
                      hint: const Text('Select Chapter'),
                      isExpanded: true,
                      items: _chapters.map((chapter) {
                        return DropdownMenuItem<String>(
                          value: chapter.id,
                          child: Text('Chapter ${chapter.number}'),
                        );
                      }).toList(),
                      onChanged: _onChapterChanged,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoadingBibles) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Bibles...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBibles,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_selectedBibleId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Select a Bible to begin reading',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoadingBooks) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading books...'),
          ],
        ),
      );
    }

    if (_selectedBookId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Select a book to begin reading',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoadingChapters) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading chapters...'),
          ],
        ),
      );
    }

    if (_selectedChapterId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Select a chapter to begin reading',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoadingVerses) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading verses...'),
          ],
        ),
      );
    }

    if (_verses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.text_snippet_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No verses found for this chapter',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Display verses
    final shouldUseWebLayout = PlatformHelper.shouldUseWebLayout(context);
    final padding = shouldUseWebLayout 
        ? PlatformHelper.getResponsivePadding(context)
        : const EdgeInsets.all(16);
    
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chapter header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(shouldUseWebLayout ? 24 : 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_books.firstWhere((book) => book.id == _selectedBookId).name} ${_chapters.firstWhere((chapter) => chapter.id == _selectedChapterId).number}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: shouldUseWebLayout ? 28 : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: shouldUseWebLayout ? 24 : 16),
          
          // Verses with responsive layout
          if (shouldUseWebLayout) ...[
            // Web layout - wider text with larger font
            ..._verses.map((verse) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(
                      text: '${verse.verseNumber} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                    TextSpan(text: verse.text),
                  ],
                ),
              ),
            )),
          ] else ...[
            // Mobile layout - compact text
            ..._verses.map((verse) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: '${verse.verseNumber} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(text: verse.text),
                  ],
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }
}
