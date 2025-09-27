import 'package:flutter/material.dart';
import '../models/church.dart';
import '../services/bible_study_service.dart';
import '../widgets/church_card.dart';

class ChurchesPage extends StatefulWidget {
  const ChurchesPage({super.key});

  @override
  State<ChurchesPage> createState() => _ChurchesPageState();
}

class _ChurchesPageState extends State<ChurchesPage> {
  final _locationController = TextEditingController();
  String _selectedDenomination = '';
  double _maxDistance = 25.0;
  List<String> _selectedServiceTypes = [];
  List<Church> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    // Remove automatic search - let users search manually for better performance
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await BibleStudyService.searchChurches(
        _locationController.text.isEmpty ? null : _locationController.text,
        denomination: _selectedDenomination.isEmpty ? null : _selectedDenomination,
        maxDistance: _maxDistance,
        preferredServices: _selectedServiceTypes,
      );
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
            content: Text('Error searching churches: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetFilters() {
    setState(() {
      _locationController.clear();
      _selectedDenomination = '';
      _maxDistance = 25.0;
      _selectedServiceTypes.clear();
      _searchResults.clear();
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
                  Icons.church,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  'Find Local Churches',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover welcoming church communities in your area. Find worship services, ministries, and spiritual homes that align with your faith journey.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Search Filters
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tune,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Search Filters',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Location Field
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      hintText: 'City, State or ZIP code',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLength: 100,
                  ),

                  const SizedBox(height: 16),

                  // Denomination Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedDenomination.isEmpty ? null : _selectedDenomination,
                    decoration: const InputDecoration(
                      labelText: 'Denomination',
                      prefixIcon: Icon(Icons.account_balance),
                    ),
                    items: BibleStudyService.getDenominationOptions()
                        .map((denomination) => DropdownMenuItem(
                              value: denomination,
                              child: Text(denomination),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDenomination = value ?? '';
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Distance Slider
                  Text(
                    'Maximum Distance: ${_maxDistance >= 100 ? '100+ miles' : '${_maxDistance.round()} miles'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
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

                  const SizedBox(height: 24),

                  // Service Types
                  Text(
                    'Preferred Service Types:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: BibleStudyService.getServiceTypeOptions().map((type) {
                      final isSelected = _selectedServiceTypes.contains(type);
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedServiceTypes.add(type);
                            } else {
                              _selectedServiceTypes.remove(type);
                            }
                          });
                        },
                        selectedColor: Theme.of(context).colorScheme.primaryContainer,
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
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
                            _isLoading ? 'Searching...' : 'Find Churches',
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
                          onPressed: _resetFilters,
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
                            Text('Searching for churches in your area...'),
                          ],
                        ),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Icon(
                            Icons.church,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _searchResults.isNotEmpty
                                ? 'Found ${_searchResults.length} church${_searchResults.length == 1 ? '' : 'es'}'
                                : 'No churches found',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (_searchResults.isEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search criteria to find more churches.',
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
                            return ChurchCard(church: _searchResults[index]);
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
          if (!_hasSearched && !_isLoading) ...[
            const SizedBox(height: 24),
            const _ChurchTipsSection(),
          ],
        ],
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
          Icons.church_outlined,
          size: 64,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Text(
          'No Churches Found',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We couldn\'t find any churches matching your criteria. Here are some suggestions:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Try expanding your search distance'),
            Text('• Remove denomination filter to see more options'),
            Text('• Check nearby cities or areas'),
            Text('• Try different service type preferences'),
          ],
        ),
      ],
    );
  }
}

class _ChurchTipsSection extends StatelessWidget {
  const _ChurchTipsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tips for Finding the Right Church',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const _TipItem(
              icon: '🏛️',
              title: 'Denomination Matters',
              description: 'Consider denominations that align with your theological beliefs and worship preferences.',
            ),
            const _TipItem(
              icon: '⏰',
              title: 'Service Times',
              description: 'Look for service times that work with your schedule and family commitments.',
            ),
            const _TipItem(
              icon: '👨‍👩‍👧‍👦',
              title: 'Family Needs',
              description: 'Check for childcare, youth programs, and family-friendly services if you have children.',
            ),
            const _TipItem(
              icon: '🤝',
              title: 'Community Connection',
              description: 'Visit multiple churches to find one where you feel welcomed and can build relationships.',
            ),
            const _TipItem(
              icon: '🎯',
              title: 'Ministry Focus',
              description: 'Look for churches with ministries and outreach programs that align with your interests.',
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
