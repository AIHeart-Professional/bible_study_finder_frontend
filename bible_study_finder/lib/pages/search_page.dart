import 'package:flutter/material.dart';
import '../models/bible_study_group.dart';
import '../models/search_criteria.dart';
import '../services/bible_study_service.dart';
import '../widgets/study_group_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchTermController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedStudyType = '';
  String _selectedMeetingDay = '';
  String _selectedMeetingTime = '';
  String _selectedAgeGroup = '';
  String _selectedLanguage = '';
  double _maxDistance = 25.0;
  double _maxGroupSize = 50.0;
  bool _isOnline = false;
  bool _isInPerson = true;
  bool _isChildcareAvailable = false;
  bool _isBeginnersWelcome = true;

  List<BibleStudyGroup> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  bool _showAdvancedFilters = false; // Progressive disclosure

  @override
  void dispose() {
    _searchTermController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (!_isOnline && !_isInPerson) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one meeting type (Online or In-person).'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final criteria = SearchCriteria(
      searchTerm: _searchTermController.text,
      location: _locationController.text,
      studyType: _selectedStudyType,
      meetingDay: _selectedMeetingDay,
      meetingTime: _selectedMeetingTime,
      ageGroup: _selectedAgeGroup,
      language: _selectedLanguage,
      maxDistance: _maxDistance.round(),
      groupSize: _maxGroupSize.round(),
      isOnline: _isOnline,
      isInPerson: _isInPerson,
      isChildcareAvailable: _isChildcareAvailable,
      isBeginnersWelcome: _isBeginnersWelcome,
    );

    try {
      final results = await BibleStudyService.searchGroups(criteria);
      setState(() {
        _searchResults = results;
        _hasSearched = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching groups: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
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
                  Icon(
                    Icons.search,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Find Your Bible Study Group',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connect with local believers and join a Bible study group that matches your preferences and schedule.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick search removed for now - will implement in next iteration

            const SizedBox(height: 24),

            // Search Form
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with toggle
                    Row(
                      children: [
                        Icon(
                          _showAdvancedFilters ? Icons.tune : Icons.search,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _showAdvancedFilters ? 'Advanced Search' : 'Quick Search',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showAdvancedFilters = !_showAdvancedFilters;
                            });
                          },
                          icon: Icon(
                            _showAdvancedFilters ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                          label: Text(_showAdvancedFilters ? 'Simple' : 'Advanced'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _searchTermController,
                      decoration: const InputDecoration(
                        labelText: 'Search Keywords',
                        hintText: 'e.g., Romans, prayer, discipleship...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      maxLength: 100,
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'City, State or ZIP code',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      maxLength: 100,
                    ),

                    const SizedBox(height: 24),

                    // Advanced Filters (Progressive Disclosure)
                    if (_showAdvancedFilters) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.filter_list,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Advanced Filters',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _selectedStudyType.isEmpty ? null : _selectedStudyType,
                      decoration: const InputDecoration(
                        labelText: 'Study Type',
                        prefixIcon: Icon(Icons.book),
                      ),
                      items: BibleStudyService.getStudyTypeOptions()
                          .map((option) => DropdownMenuItem(
                                value: option['value']!.isEmpty ? null : option['value'],
                                child: Text(option['label']!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStudyType = value ?? '';
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedMeetingDay.isEmpty ? null : _selectedMeetingDay,
                            decoration: const InputDecoration(
                              labelText: 'Meeting Day',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            items: BibleStudyService.getMeetingDayOptions()
                                .map((option) => DropdownMenuItem(
                                      value: option['value']!.isEmpty ? null : option['value'],
                                      child: Text(option['label']!),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMeetingDay = value ?? '';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedMeetingTime.isEmpty ? null : _selectedMeetingTime,
                            decoration: const InputDecoration(
                              labelText: 'Meeting Time',
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            items: BibleStudyService.getMeetingTimeOptions()
                                .map((option) => DropdownMenuItem(
                                      value: option['value']!.isEmpty ? null : option['value'],
                                      child: Text(option['label']!),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMeetingTime = value ?? '';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedAgeGroup.isEmpty ? null : _selectedAgeGroup,
                            decoration: const InputDecoration(
                              labelText: 'Age Group',
                              prefixIcon: Icon(Icons.people),
                            ),
                            items: BibleStudyService.getAgeGroupOptions()
                                .map((option) => DropdownMenuItem(
                                      value: option['value']!.isEmpty ? null : option['value'],
                                      child: Text(option['label']!),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedAgeGroup = value ?? '';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedLanguage.isEmpty ? null : _selectedLanguage,
                            decoration: const InputDecoration(
                              labelText: 'Language',
                              prefixIcon: Icon(Icons.language),
                            ),
                            items: BibleStudyService.getLanguageOptions()
                                .map((option) => DropdownMenuItem(
                                      value: option['value']!.isEmpty ? null : option['value'],
                                      child: Text(option['label']!),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguage = value ?? '';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sliders
                    Text(
                      'Distance & Group Size',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Maximum Distance: ${_maxDistance >= 100 ? '100+ miles' : '${_maxDistance.round()} miles'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: _maxDistance,
                      min: 1,
                      max: 100,
                      divisions: 99,
                      onChanged: (value) {
                        setState(() {
                          _maxDistance = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Maximum Group Size: ${_maxGroupSize >= 100 ? '100+ people' : '${_maxGroupSize.round()} people'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: _maxGroupSize,
                      min: 5,
                      max: 100,
                      divisions: 19,
                      onChanged: (value) {
                        setState(() {
                          _maxGroupSize = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Checkboxes
                    Text(
                      'Meeting Options',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    CheckboxListTile(
                      title: const Text('Online meetings'),
                      value: _isOnline,
                      onChanged: (value) {
                        setState(() {
                          _isOnline = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    CheckboxListTile(
                      title: const Text('In-person meetings'),
                      value: _isInPerson,
                      onChanged: (value) {
                        setState(() {
                          _isInPerson = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    CheckboxListTile(
                      title: const Text('Childcare available'),
                      value: _isChildcareAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isChildcareAvailable = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),

                    CheckboxListTile(
                      title: const Text('Beginners welcome'),
                      value: _isBeginnersWelcome,
                      onChanged: (value) {
                        setState(() {
                          _isBeginnersWelcome = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Action Buttons - Enhanced
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _performSearch,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.search, size: 20),
                            label: Text(
                              _isLoading ? 'Searching...' : 'Search Groups',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _searchTermController.clear();
                                _locationController.clear();
                                _selectedStudyType = '';
                                _selectedMeetingDay = '';
                                _selectedMeetingTime = '';
                                _selectedAgeGroup = '';
                                _selectedLanguage = '';
                                _maxDistance = 25.0;
                                _maxGroupSize = 50.0;
                                _isOnline = false;
                                _isInPerson = true;
                                _isChildcareAvailable = false;
                                _isBeginnersWelcome = true;
                                _searchResults = [];
                                _hasSearched = false;
                              });
                            },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Reset'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search Results Section
            if (_hasSearched || _isLoading) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isLoading) ...[
                        const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Searching for Bible study groups...'),
                            ],
                          ),
                        ),
                      ] else ...[
                        Text(
                          _searchResults.isNotEmpty
                              ? 'Found ${_searchResults.length} group${_searchResults.length == 1 ? '' : 's'}'
                              : 'No groups found',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_searchResults.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search criteria to find more groups.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        const SizedBox(height: 16),
                        if (_searchResults.isNotEmpty) ...[
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _searchResults.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              return StudyGroupCard(group: _searchResults[index]);
                            },
                          ),
                        ] else ...[
                          const _NoResultsWidget(),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],

            // Tips Section (only shown when no search has been performed)
            if (!_hasSearched) ...[
              const SizedBox(height: 24),
              const _TipsSection(),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoResultsWidget extends StatelessWidget {
  const _NoResultsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.search_off,
          size: 64,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Text(
          'No Bible Study Groups Found',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We couldn\'t find any groups matching your criteria. Here are some suggestions:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Try expanding your search distance'),
            Text('• Remove some filters to see more results'),
            Text('• Check both online and in-person options'),
            Text('• Try different keywords or study types'),
          ],
        ),
      ],
    );
  }
}

class _TipsSection extends StatelessWidget {
  const _TipsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tips for Finding the Right Group',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const _TipItem(
              icon: '📍',
              title: 'Location Matters',
              description: 'Consider both proximity to your home and accessibility by public transport.',
            ),
            const _TipItem(
              icon: '⏰',
              title: 'Schedule Flexibility',
              description: 'Look for groups that meet at times that work consistently with your schedule.',
            ),
            const _TipItem(
              icon: '👥',
              title: 'Group Size',
              description: 'Smaller groups offer more intimate discussion, while larger groups provide diverse perspectives.',
            ),
            const _TipItem(
              icon: '📚',
              title: 'Study Style',
              description: 'Consider whether you prefer structured curriculum or open discussion formats.',
            ),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final String icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

