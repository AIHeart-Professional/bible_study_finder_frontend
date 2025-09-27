import 'package:flutter/material.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  String selectedVersion = 'NIV';
  String selectedBook = 'Genesis';
  int selectedChapter = 1;
  bool isReading = false;

  final List<String> bibleVersions = [
    'NIV', 'ESV', 'NASB', 'KJV', 'NLT', 'CSB', 'NKJV', 'MSG'
  ];

  final List<String> oldTestamentBooks = [
    'Genesis', 'Exodus', 'Leviticus', 'Numbers', 'Deuteronomy',
    'Joshua', 'Judges', 'Ruth', '1 Samuel', '2 Samuel',
    '1 Kings', '2 Kings', '1 Chronicles', '2 Chronicles', 'Ezra',
    'Nehemiah', 'Esther', 'Job', 'Psalms', 'Proverbs',
    'Ecclesiastes', 'Song of Songs', 'Isaiah', 'Jeremiah', 'Lamentations',
    'Ezekiel', 'Daniel', 'Hosea', 'Joel', 'Amos',
    'Obadiah', 'Jonah', 'Micah', 'Nahum', 'Habakkuk',
    'Zephaniah', 'Haggai', 'Zechariah', 'Malachi'
  ];

  final List<String> newTestamentBooks = [
    'Matthew', 'Mark', 'Luke', 'John', 'Acts',
    'Romans', '1 Corinthians', '2 Corinthians', 'Galatians', 'Ephesians',
    'Philippians', 'Colossians', '1 Thessalonians', '2 Thessalonians', '1 Timothy',
    '2 Timothy', 'Titus', 'Philemon', 'Hebrews', 'James',
    '1 Peter', '2 Peter', '1 John', '2 John', '3 John',
    'Jude', 'Revelation'
  ];

  @override
  Widget build(BuildContext context) {
    if (isReading) {
      return _buildReaderView();
    }
    
    return _buildSelectionView();
  }

  Widget _buildSelectionView() {
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedVersion,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select Bible Version',
                    ),
                    items: bibleVersions.map((version) {
                      return DropdownMenuItem(
                        value: version,
                        child: Text(version),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVersion = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Book Selection
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
                  
                  // Old Testament
                  ExpansionTile(
                    title: const Text('Old Testament'),
                    initiallyExpanded: oldTestamentBooks.contains(selectedBook),
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: oldTestamentBooks.map((book) {
                          final isSelected = selectedBook == book;
                          return FilterChip(
                            label: Text(book),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedBook = book;
                                selectedChapter = 1;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  
                  // New Testament
                  ExpansionTile(
                    title: const Text('New Testament'),
                    initiallyExpanded: newTestamentBooks.contains(selectedBook),
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: newTestamentBooks.map((book) {
                          final isSelected = selectedBook == book;
                          return FilterChip(
                            label: Text(book),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedBook = book;
                                selectedChapter = 1;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Chapter Selection
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
                        'Chapter $selectedChapter',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: selectedChapter.toDouble(),
                    min: 1,
                    max: _getMaxChapters(selectedBook).toDouble(),
                    divisions: _getMaxChapters(selectedBook) - 1,
                    label: 'Chapter $selectedChapter',
                    onChanged: (value) {
                      setState(() {
                        selectedChapter = value.round();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Chapter 1'),
                      Text('Chapter ${_getMaxChapters(selectedBook)}'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Start Reading Button
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isReading = true;
              });
            },
            icon: const Icon(Icons.play_arrow),
            label: Text('Start Reading $selectedBook $selectedChapter'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
          ),
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
                  '$selectedBook $selectedChapter ($selectedVersion)',
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Demo Bible text - In a real app, this would come from an API
                _buildBibleText(),
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
                onPressed: selectedChapter > 1 ? () {
                  setState(() {
                    selectedChapter--;
                  });
                } : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
              Text(
                'Chapter $selectedChapter',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              OutlinedButton.icon(
                onPressed: selectedChapter < _getMaxChapters(selectedBook) ? () {
                  setState(() {
                    selectedChapter++;
                  });
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
    // Demo content - In a real app, this would be fetched from a Bible API
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 1; i <= 20; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: '$i ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: _getDemoVerse(selectedBook, selectedChapter, i),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  int _getMaxChapters(String book) {
    // Simplified chapter counts - in a real app, this would be more comprehensive
    final chapterCounts = {
      'Genesis': 50, 'Exodus': 40, 'Matthew': 28, 'Mark': 16, 
      'Luke': 24, 'John': 21, 'Acts': 28, 'Romans': 16,
      'Psalms': 150, 'Proverbs': 31, 'Isaiah': 66, 'Jeremiah': 52,
    };
    return chapterCounts[book] ?? 25; // Default to 25 if not specified
  }

  String _getDemoVerse(String book, int chapter, int verse) {
    // Demo verses - In a real app, this would come from a Bible API
    if (book == 'Genesis' && chapter == 1) {
      switch (verse) {
        case 1: return 'In the beginning God created the heavens and the earth.';
        case 2: return 'Now the earth was formless and empty, darkness was over the surface of the deep, and the Spirit of God was hovering over the waters.';
        case 3: return 'And God said, "Let there be light," and there was light.';
        default: return 'This is a demo verse from $book $chapter:$verse. In a real app, this would be the actual Bible text from your chosen version.';
      }
    }
    return 'This is a demo verse from $book $chapter:$verse ($selectedVersion). In a real app, this would connect to a Bible API to display the actual scripture text.';
  }
}
