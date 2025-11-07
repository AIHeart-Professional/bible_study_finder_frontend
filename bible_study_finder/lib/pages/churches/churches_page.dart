import 'package:flutter/material.dart';
import '../../models/church/church.dart';
import '../../services/church_service.dart';
import '../../widgets/church_card.dart';
import '../../utils/platform_helper.dart';

class ChurchesPage extends StatefulWidget {
  const ChurchesPage({super.key});

  @override
  State<ChurchesPage> createState() => _ChurchesPageState();
}

class _ChurchesPageState extends State<ChurchesPage> {
  final _locationController = TextEditingController();
  String _selectedDenomination = '';
  double _maxDistance = 25.0;
  List<String> _preferredServices = [];

  List<Church> _churches = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _performSearch(); // Initial search with default criteria
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
      final results = await ChurchService.searchChurches(
        _locationController.text.isEmpty ? null : _locationController.text,
        denomination: _selectedDenomination.isEmpty ? null : _selectedDenomination,
        maxDistance: _maxDistance,
        preferredServices: _preferredServices,
      );
      
      setState(() {
        _churches = results;
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
            content: Text('Error searching churches: $e'),
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
        initialChildSize: 0.7,
        maxChildSize: 0.9,
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
                  'Filter Churches',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Denomination
                    Text(
                      'Denomination',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDenomination.isEmpty ? null : _selectedDenomination,
                      decoration: const InputDecoration(
                        hintText: 'Any Denomination',
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: '',
                          child: Text('Any Denomination'),
                        ),
                        ...ChurchService.getDenominationOptions().map((denomination) {
                          return DropdownMenuItem<String>(
                            value: denomination,
                            child: Text(denomination),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDenomination = value ?? '';
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

                    // Service Types
                    Text(
                      'Preferred Service Types',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ChurchService.getServiceTypeOptions().map((serviceType) {
                        final isSelected = _preferredServices.contains(serviceType);
                        return FilterChip(
                          label: Text(serviceType),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _preferredServices.add(serviceType);
                              } else {
                                _preferredServices.remove(serviceType);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
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
                  'Find Churches',
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
                      // Search field
                      TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your location...',
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
                          label: const Text('Search Churches'),
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
                        '${_churches.length} churches found',
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
                      controller: _locationController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your location...',
                        prefixIcon: Icon(Icons.location_on),
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
              ElevatedButton(
                onPressed: _performSearch,
                child: const Text('Search Churches'),
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
            Text('Searching for churches...'),
          ],
        ),
      );
    }

    if (_hasSearched) {
      if (_churches.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.church_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No churches found',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search criteria or location',
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
              childAspectRatio: 1.1,
            ),
            itemCount: _churches.length,
            itemBuilder: (context, index) {
              final church = _churches[index];
              return ChurchCard(church: church);
            },
          );
        } else {
          // List layout for mobile
          return ListView.builder(
            padding: padding,
            itemCount: _churches.length,
            itemBuilder: (context, index) {
              final church = _churches[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ChurchCard(church: church),
              );
            },
          );
        }
      }
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildInlineFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Denomination
        Text(
          'Denomination',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _selectedDenomination.isEmpty ? null : _selectedDenomination,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: [
            const DropdownMenuItem<String>(
              value: '',
              child: Text('Any Denomination', style: TextStyle(fontSize: 12)),
            ),
            ...ChurchService.getDenominationOptions().map((denomination) {
              return DropdownMenuItem<String>(
                value: denomination,
                child: Text(denomination, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              _selectedDenomination = value ?? '';
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

        // Service Types
        Text(
          'Service Types',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: ChurchService.getServiceTypeOptions().map((serviceType) {
            final isSelected = _preferredServices.contains(serviceType);
            return FilterChip(
              label: Text(serviceType, style: const TextStyle(fontSize: 11)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _preferredServices.add(serviceType);
                  } else {
                    _preferredServices.remove(serviceType);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
