import 'package:flutter/material.dart';
import '../models/bible.dart';
import '../services/bible_service.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  // State variables
  Bible? selectedBible;
  Book? selectedBook;
  Chapter? selectedChapter;
  bool isReading = false;
  bool isLoading = false;
  String? errorMessage;

  // Data lists
  List<Bible> bibles = [];
  List<Book> books = [];
  List<Chapter> chapters = [];
  String chapterContent = '';

  @override
  void initState() {
    super.initState();
    _loadBibles();
  }


  // Load available Bible versions
  Future<void> _loadBibles() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final availableBibles = await BibleService.getBibles();
      setState(() {
        bibles = availableBibles;
        selectedBible = availableBibles.isNotEmpty ? availableBibles.first : null;
        isLoading = false;
      });
      
      if (selectedBible != null) {
        _loadBooks(selectedBible!.id);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load Bible versions: $e';
        isLoading = false;
      });
    }
  }

  // Load books for selected Bible
  Future<void> _loadBooks(String bibleId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final availableBooks = await BibleService.getBooks(bibleId);
      setState(() {
        books = availableBooks;
        selectedBook = availableBooks.isNotEmpty ? availableBooks.first : null;
        isLoading = false;
      });
      
      if (selectedBook != null) {
        _loadChapters(bibleId, selectedBook!.id);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load books: $e';
        isLoading = false;
      });
    }
  }

  // Load chapters for selected book
  Future<void> _loadChapters(String bibleId, String bookId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final availableChapters = await BibleService.getChapters(bibleId, bookId);
      setState(() {
        chapters = availableChapters;
        selectedChapter = availableChapters.isNotEmpty ? availableChapters.first : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load chapters: $e';
        isLoading = false;
      });
    }
  }

  // Load chapter content
  Future<void> _loadChapterContent(String bibleId, String chapterId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final content = await BibleService.getChapterContent(bibleId, chapterId);
      setState(() {
        chapterContent = content;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load chapter content: $e';
        isLoading = false;
      });
      
      // Show detailed error for debugging
      print('Error loading chapter content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isReading) {
      return _buildReaderView();
    }
    
    return _buildSelectionView();
  }

  Widget _buildSelectionView() {
    if (isLoading && bibles.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.menu_book,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Read the Bible',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your version and dive into God\'s Word',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),

          // Bible Version Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.translate,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Bible Version',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        if (isLoading && books.isEmpty) ...[
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Bible>(
                    value: selectedBible,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select Bible Version',
                    ),
                    items: bibles.map((bible) {
                      return DropdownMenuItem(
                        value: bible,
                        child: Text('${bible.name} (${bible.abbreviation})'),
                      );
                    }).toList(),
                    onChanged: (bible) {
                      if (bible != null) {
                        setState(() {
                          selectedBible = bible;
                          selectedBook = null;
                          selectedChapter = null;
                          books.clear();
                          chapters.clear();
                        });
                        _loadBooks(bible.id);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Book Selection
          if (selectedBible != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.library_books,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Select Book',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (books.isNotEmpty) ...[
                      // Old Testament
                      ExpansionTile(
                        title: const Text('Old Testament'),
                        initiallyExpanded: selectedBook?.isOldTestament ?? false,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: books.where((book) => book.isOldTestament).map((book) {
                              final isSelected = selectedBook?.id == book.id;
                              return FilterChip(
                                label: Text(book.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedBook = book;
                                    selectedChapter = null;
                                    chapters.clear();
                                  });
                                  _loadChapters(selectedBible!.id, book.id);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      
                      // New Testament
                      ExpansionTile(
                        title: const Text('New Testament'),
                        initiallyExpanded: selectedBook?.isNewTestament ?? false,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: books.where((book) => book.isNewTestament).map((book) {
                              final isSelected = selectedBook?.id == book.id;
                              return FilterChip(
                                label: Text(book.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedBook = book;
                                    selectedChapter = null;
                                    chapters.clear();
                                  });
                                  _loadChapters(selectedBible!.id, book.id);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ] else if (isLoading) ...[
                      const Center(child: CircularProgressIndicator()),
                    ] else ...[
                      const Center(child: Text('No books available')),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Chapter Selection
            if (selectedBook != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.format_list_numbered,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            selectedChapter != null 
                                ? 'Chapter ${selectedChapter!.chapterNumber}'
                                : 'Select Chapter',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      if (chapters.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: chapters.map((chapter) {
                            final isSelected = selectedChapter?.id == chapter.id;
                            return FilterChip(
                              label: Text('Chapter ${chapter.chapterNumber}'),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedChapter = chapter;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Start Reading Button
              if (selectedChapter != null)
                ElevatedButton.icon(
                  onPressed: () async {
                    if (selectedBible != null && selectedChapter != null) {
                      await _loadChapterContent(selectedBible!.id, selectedChapter!.id);
                      setState(() {
                        isReading = true;
                      });
                    }
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: Text('Start Reading ${selectedBook!.name} Chapter ${selectedChapter!.chapterNumber}'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildReaderView() {
    return Column(
      children: [
        // Reader Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isReading = false;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  '${selectedBook?.name ?? ''} Chapter ${selectedChapter?.chapterNumber ?? ''} (${selectedBible?.abbreviation ?? ''})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Add bookmark functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bookmark added!')),
                  );
                },
                icon: const Icon(Icons.bookmark_add),
              ),
            ],
          ),
        ),
        
        // Bible Text
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading content',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedBible != null && selectedChapter != null) {
                                _loadChapterContent(selectedBible!.id, selectedChapter!.id);
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (chapterContent.isNotEmpty)
                            _buildBibleText()
                          else
                            const Center(
                              child: Text('No content available'),
                            ),
                        ],
                      ),
                    ),
        ),
        
        // Navigation Controls
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: _canGoToPreviousChapter() ? () {
                  _goToPreviousChapter();
                } : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
              Text(
                'Chapter ${selectedChapter?.chapterNumber ?? ''}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              OutlinedButton.icon(
                onPressed: _canGoToNextChapter() ? () {
                  _goToNextChapter();
                } : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBibleText() {
    return Text(
      chapterContent,
      style: TextStyle(
        fontSize: 18,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  // Navigation helper methods
  bool _canGoToPreviousChapter() {
    if (selectedChapter == null || chapters.isEmpty) return false;
    final currentIndex = chapters.indexWhere((c) => c.id == selectedChapter!.id);
    return currentIndex > 0;
  }

  bool _canGoToNextChapter() {
    if (selectedChapter == null || chapters.isEmpty) return false;
    final currentIndex = chapters.indexWhere((c) => c.id == selectedChapter!.id);
    return currentIndex < chapters.length - 1;
  }

  void _goToPreviousChapter() {
    if (!_canGoToPreviousChapter()) return;
    
    final currentIndex = chapters.indexWhere((c) => c.id == selectedChapter!.id);
    final previousChapter = chapters[currentIndex - 1];
    
    setState(() {
      selectedChapter = previousChapter;
      chapterContent = '';
    });
    
    if (selectedBible != null) {
      _loadChapterContent(selectedBible!.id, previousChapter.id);
    }
  }

  void _goToNextChapter() {
    if (!_canGoToNextChapter()) return;
    
    final currentIndex = chapters.indexWhere((c) => c.id == selectedChapter!.id);
    final nextChapter = chapters[currentIndex + 1];
    
    setState(() {
      selectedChapter = nextChapter;
      chapterContent = '';
    });
    
    if (selectedBible != null) {
      _loadChapterContent(selectedBible!.id, nextChapter.id);
    }
  }
}
