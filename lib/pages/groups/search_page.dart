import 'package:flutter/material.dart';
import '../../models/group/bible_study_group.dart';
import '../../models/group/search_criteria.dart';
import '../../services/group/group_service.dart';
import '../../widgets/study_group_card.dart';
import '../../utils/platform_helper.dart';
import '../../utils/logger.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _logger = getLogger('SearchPage');
  final _formKey = GlobalKey<FormState>();
  final _searchTermController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedStudyType = '';
  String _selectedMeetingDay = '';
  String _selectedLanguage = '';
  String _selectedAgeGroup = '';
  double _maxDistance = 25.0;
  int _maxGroupSize = 50;
  bool _isOnline = false;
  bool _isInPerson = false;
  bool _isChildcareAvailable = false;
  bool _isBeginnersWelcome = false;

  List<BibleStudyGroup> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadGroupsFromAPI(); // Load groups from API when tab is selected
  }

  Future<void> _loadGroupsFromAPI() async {
    _logger.info('Loading groups from API...');
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final groups = await GroupService.getGroups();
      _logger.info('Successfully loaded ${groups.length} groups');
      
      if (!mounted) return;
      setState(() {
        _searchResults = groups;
        _isLoading = false;
        _hasSearched = true;
      });
    } catch (e, stackTrace) {
      _logger.error('Error loading groups', error: e, stackTrace: stackTrace);
      
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasSearched = true;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading groups: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchTermController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final criteria = SearchCriteria(
        searchTerm: _searchTermController.text,
        location: _locationController.text,
        studyType: _selectedStudyType,
        meetingDay: _selectedMeetingDay,
        language: _selectedLanguage,
        ageGroup: _selectedAgeGroup,
        maxDistance: _maxDistance.toInt(),
        groupSize: _maxGroupSize,
        isOnline: _isOnline,
        isInPerson: _isInPerson,
        isChildcareAvailable: _isChildcareAvailable,
        isBeginnersWelcome: _isBeginnersWelcome,
      );

      final results = await GroupService.searchGroups(criteria);
      
      setState(() {
        _searchResults = results;
        _isLoading = false;
        _hasSearched = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasSearched = true;
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Filter Groups',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Study Type
                      Text(
                        'Study Type',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedStudyType.isEmpty ? null : _selectedStudyType,
                        decoration: const InputDecoration(
                          hintText: 'Any Study Type',
                        ),
                        items: GroupService.getStudyTypeOptions().map((option) {
                          return DropdownMenuItem<String>(
                            value: option['value'],
                            child: Text(option['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStudyType = value ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Meeting Day
                      Text(
                        'Meeting Day',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedMeetingDay.isEmpty ? null : _selectedMeetingDay,
                        decoration: const InputDecoration(
                          hintText: 'Any Day',
                        ),
                        items: GroupService.getMeetingDayOptions().map((option) {
                          return DropdownMenuItem<String>(
                            value: option['value'],
                            child: Text(option['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMeetingDay = value ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Language
                      Text(
                        'Language',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedLanguage.isEmpty ? null : _selectedLanguage,
                        decoration: const InputDecoration(
                          hintText: 'Any Language',
                        ),
                        items: GroupService.getLanguageOptions().map((option) {
                          return DropdownMenuItem<String>(
                            value: option['value'],
                            child: Text(option['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Age Group
                      Text(
                        'Age Group',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedAgeGroup.isEmpty ? null : _selectedAgeGroup,
                        decoration: const InputDecoration(
                          hintText: 'Any Age Group',
                        ),
                        items: GroupService.getAgeGroupOptions().map((option) {
                          return DropdownMenuItem<String>(
                            value: option['value'],
                            child: Text(option['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAgeGroup = value ?? '';
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Distance
                      Text(
                        'Maximum Distance: ${_maxDistance.toStringAsFixed(1)} miles',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        value: _maxDistance,
                        min: 1.0,
                        max: 50.0,
                        divisions: 49,
                        onChanged: (value) {
                          setState(() {
                            _maxDistance = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Group Size
                      Text(
                        'Maximum Group Size: ${_maxGroupSize == 0 ? 'Any' : _maxGroupSize}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        value: _maxGroupSize.toDouble(),
                        min: 0.0,
                        max: 100.0,
                        divisions: 20,
                        onChanged: (value) {
                          setState(() {
                            _maxGroupSize = value.round();
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Checkboxes
                      CheckboxListTile(
                        title: const Text('Online Groups'),
                        subtitle: const Text('Groups that meet online'),
                        value: _isOnline,
                        onChanged: (value) {
                          setState(() {
                            _isOnline = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('In-Person Groups'),
                        subtitle: const Text('Groups that meet in person'),
                        value: _isInPerson,
                        onChanged: (value) {
                          setState(() {
                            _isInPerson = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Childcare Available'),
                        subtitle: const Text('Groups that provide childcare'),
                        value: _isChildcareAvailable,
                        onChanged: (value) {
                          setState(() {
                            _isChildcareAvailable = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Beginners Welcome'),
                        subtitle: const Text('Groups that welcome beginners'),
                        value: _isBeginnersWelcome,
                        onChanged: (value) {
                          setState(() {
                            _isBeginnersWelcome = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _performSearch();
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
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
        // Left sidebar with search and filters
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                  'Search Groups',
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
                    children: [
                      // Search fields
                      TextField(
                        controller: _searchTermController,
                        decoration: const InputDecoration(
                          hintText: 'Search groups...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _performSearch(),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: 'Location (optional)',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _performSearch(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _performSearch,
                          icon: const Icon(Icons.search),
                          label: const Text('Search'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Inline filters for web
                      Text(
                        'Filters',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInlineFilters(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Right panel with results
        Expanded(
          child: Column(
            children: [
              Container(
                padding: PlatformHelper.getResponsivePadding(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search Results',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_hasSearched)
                      Text(
                        '${_searchResults.length} groups found',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: _buildResults(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchTermController,
                      decoration: InputDecoration(
                        hintText: 'Search groups...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchTermController.clear();
                            _performSearch();
                          },
                        ),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _showFilterBottomSheet,
                    icon: const Icon(Icons.filter_list),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        hintText: 'Location (optional)',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _performSearch,
                    child: const Text('Search'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Results
        Expanded(
          child: _buildResults(context),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching for groups...'),
          ],
        ),
      );
    }

    if (_hasSearched) {
      if (_searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No groups found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search criteria',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _showFilterBottomSheet,
                icon: const Icon(Icons.tune),
                label: const Text('Adjust Filters'),
              ),
            ],
          ),
        );
      } else {
        final shouldUseWebLayout = PlatformHelper.shouldUseWebLayout(context);
        final padding = shouldUseWebLayout 
            ? PlatformHelper.getResponsivePadding(context)
            : const EdgeInsets.symmetric(horizontal: 16);
        
        if (shouldUseWebLayout) {
          // Grid layout for web
          return GridView.builder(
            padding: padding,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final group = _searchResults[index];
              return StudyGroupCard(
                group: group,
                onMembershipChanged: () {
                  _loadGroupsFromAPI();
                },
              );
            },
          );
        } else {
          // List layout for mobile
          return ListView.builder(
            padding: padding,
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final group = _searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: StudyGroupCard(
                  group: group,
                  onMembershipChanged: () {
                    _loadGroupsFromAPI();
                  },
                ),
              );
            },
          );
        }
      }
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildInlineFilters() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Study Type
          Text(
            'Study Type',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: _selectedStudyType.isEmpty ? null : _selectedStudyType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: GroupService.getStudyTypeOptions().map((option) {
              return DropdownMenuItem<String>(
                value: option['value'],
                child: Text(option['label']!, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStudyType = value ?? '';
              });
            },
          ),
          const SizedBox(height: 12),

          // Meeting Day
          Text(
            'Meeting Day',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: _selectedMeetingDay.isEmpty ? null : _selectedMeetingDay,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: GroupService.getMeetingDayOptions().map((option) {
              return DropdownMenuItem<String>(
                value: option['value'],
                child: Text(option['label']!, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedMeetingDay = value ?? '';
              });
            },
          ),
          const SizedBox(height: 12),

          // Distance
          Text(
            'Max Distance: ${_maxDistance.toStringAsFixed(1)} miles',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
            value: _maxDistance,
            min: 1.0,
            max: 50.0,
            divisions: 49,
            onChanged: (value) {
              setState(() {
                _maxDistance = value;
              });
            },
          ),

          // Checkboxes
          CheckboxListTile(
            title: const Text('Online Groups', style: TextStyle(fontSize: 12)),
            value: _isOnline,
            onChanged: (value) {
              setState(() {
                _isOnline = value ?? false;
              });
            },
            dense: true,
          ),
          CheckboxListTile(
            title: const Text('In-Person Groups', style: TextStyle(fontSize: 12)),
            value: _isInPerson,
            onChanged: (value) {
              setState(() {
                _isInPerson = value ?? false;
              });
            },
            dense: true,
          ),
          CheckboxListTile(
            title: const Text('Childcare Available', style: TextStyle(fontSize: 12)),
            value: _isChildcareAvailable,
            onChanged: (value) {
              setState(() {
                _isChildcareAvailable = value ?? false;
              });
            },
            dense: true,
          ),
          CheckboxListTile(
            title: const Text('Beginners Welcome', style: TextStyle(fontSize: 12)),
            value: _isBeginnersWelcome,
            onChanged: (value) {
              setState(() {
                _isBeginnersWelcome = value ?? false;
              });
            },
            dense: true,
          ),
        ],
      ),
    );
  }
}
