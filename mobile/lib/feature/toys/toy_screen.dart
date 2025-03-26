import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/feature/home/blocs/set/set_bloc.dart';
import 'package:mobile/feature/home/blocs/set/set_event.dart';
import 'package:mobile/feature/home/blocs/set/set_state.dart';
import 'package:mobile/feature/home/widgets/set_card.dart';
import 'package:openapi/api.dart';

class ToyScreen extends StatefulWidget {
  const ToyScreen({super.key});

  @override
  State<ToyScreen> createState() => _ToyScreenState();
}

class _ToyScreenState extends State<ToyScreen> {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 1000);
  bool _onlyAvailable = false;
  String? _sortOption;

  final List<String> _sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Newest First',
    'Oldest First',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SetBloc>(
      create: (context) {
        final bloc = getIt<SetBloc>();
        bloc.add(
          FetchSets(
            pageable: Pageable(
              page: 0,
              size: 50,
              sort: [''],
            ),
          ),
        );
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sets'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _showFilterBottomSheet(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search sets...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _applyFilters(context);
                    },
                  ),
                ),
                onSubmitted: (_) => _applyFilters(context),
              ),
            ),
            _buildFilterChips(context),
            Expanded(
              child: BlocBuilder<SetBloc, SetState>(
                builder: (context, state) {
                  if (state.status == SetStatus.loading && state.sets == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == SetStatus.failure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage ?? 'Failed to load sets',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _refreshSets(context),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final sets = state.sets?.content ?? [];
                  final filteredSets = _filterSets(sets);

                  if (filteredSets.isEmpty) {
                    return const Center(
                      child: Text('No sets found matching your filters'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredSets.length,
                    itemBuilder: (context, index) {
                      return SetCard(
                        set: filteredSets[index],
                        onTap: () {
                          // TODO: Navigate to set detail
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (_onlyAvailable)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: const Text('In Stock'),
                selected: true,
                onSelected: (_) {
                  setState(() {
                    _onlyAvailable = false;
                  });
                  _applyFilters(context);
                },
              ),
            ),
          if (_priceRange.start > 0 || _priceRange.end < 1000)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(
                    '\$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}'),
                selected: true,
                onSelected: (_) {
                  setState(() {
                    _priceRange = const RangeValues(0, 1000);
                  });
                  _applyFilters(context);
                },
              ),
            ),
          if (_sortOption != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(_sortOption!),
                selected: true,
                onSelected: (_) {
                  setState(() {
                    _sortOption = null;
                  });
                  _applyFilters(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Sets',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Price Range',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${_priceRange.start.round()}',
                      '\$${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setModalState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Only show available sets',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Switch(
                        value: _onlyAvailable,
                        onChanged: (value) {
                          setModalState(() {
                            _onlyAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sort By',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sortOptions.length,
                      itemBuilder: (context, index) {
                        final option = _sortOptions[index];
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: _sortOption,
                          onChanged: (value) {
                            setModalState(() {
                              _sortOption = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                        _applyFilters(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<SetModel> _filterSets(List<SetModel> sets) {
    return sets.where((set) {
      // Search filter
      final searchTerm = _searchController.text.toLowerCase();
      if (searchTerm.isNotEmpty) {
        final matchesName =
            set.blindBox.name?.toLowerCase().contains(searchTerm) ?? false;
        return matchesName;
      }

      // Apply price filter if we have price information
      final price = set.sku.price?.toDouble() ?? 0.0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }

      // Apply availability filter
      if (_onlyAvailable && (set.sku.stock ?? 0) <= 0) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        // Apply sorting
        if (_sortOption == null) return 0;

        switch (_sortOption) {
          case 'Price: Low to High':
            return (a.sku.price ?? 0).compareTo(b.sku.price ?? 0);
          case 'Price: High to Low':
            return (b.sku.price ?? 0).compareTo(a.sku.price ?? 0);
          case 'Newest First':
            return b.createdAt.compareTo(a.createdAt);
          case 'Oldest First':
            return a.createdAt.compareTo(b.createdAt);
          default:
            return 0;
        }
      });
  }

  void _applyFilters(BuildContext context) {
    final setBloc = BlocProvider.of<SetBloc>(context);

    // Get current state and refresh with filters
    setBloc.add(
      RefreshSets(
        pageable: Pageable(
          page: 0,
          size: 50,
          sort: _getSortParam(),
        ),
        // Additional filter params could be added to the event if backend supports it
      ),
    );
  }

  List<String> _getSortParam() {
    if (_sortOption == null) return [''];

    switch (_sortOption) {
      case 'Price: Low to High':
        return ['sku.price,asc'];
      case 'Price: High to Low':
        return ['sku.price,desc'];
      case 'Newest First':
        return ['createdAt,desc'];
      case 'Oldest First':
        return ['createdAt,asc'];
      default:
        return [''];
    }
  }

  void _refreshSets(BuildContext context) {
    BlocProvider.of<SetBloc>(context).add(
      RefreshSets(
        pageable: Pageable(
          page: 0,
          size: 50,
          sort: _getSortParam(),
        ),
      ),
    );
  }
}
