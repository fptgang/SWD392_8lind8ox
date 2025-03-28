import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/data/models/slot_model.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:mobile/feature/home/blocs/set/set_bloc.dart';
import 'package:mobile/feature/home/blocs/set/set_event.dart';
import 'package:mobile/feature/home/blocs/set/set_state.dart';
import 'package:openapi/api.dart' as openapi;

class ToyScreen extends StatefulWidget {
  const ToyScreen({super.key});

  @override
  State<ToyScreen> createState() => _ToyScreenState();
}

class _ToyScreenState extends State<ToyScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 50000);
  bool _onlyAvailable = false;
  String? _sortOption;
  bool _isFilterVisible = false;

  // Animation controllers
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  final List<String> _sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Newest First',
    'Oldest First',
  ];

  final List<Color> _confettiColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();

    // Setup bounce animation
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
        CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut));

    // Setup rotate animation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
        CurvedAnimation(parent: _rotateController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bounceController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SetBloc>(
      create: (context) {
        final bloc = getIt<SetBloc>();
        debugPrint('[ToyScreen] Initializing SetBloc and requesting data');
        bloc.add(
          FetchSets(
            pageable: openapi.Pageable(
              page: 0,
              size: 20, // Smaller page size for better performance
              sort: ['createdAt,desc'],
            ),
            search: '',
          ),
        );
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Toy Sets'),
          backgroundColor: getColorSkin().lightOrange100,
        ),
        body: Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(child: _buildInfiniteScrollGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: getColorSkin().lightOrange100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search toy sets...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                        _applyFilters(context);
                      },
                    )
                  : null,
            ),
            onSubmitted: (_) => _applyFilters(context),
          ),
          const SizedBox(height: 10),

          // Filter Controls
          Row(
            children: [
              // Price Range
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  value: _sortOption,
                  hint: const Text('Sort By'),
                  items: _sortOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _sortOption = value;
                    });
                    _applyFilters(context);
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Only Available Switch
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      'In Stock',
                      style: TextStyle(
                        fontSize: 14,
                        color: getColorSkin().primaryRed600,
                      ),
                    ),
                    Switch(
                      value: _onlyAvailable,
                      activeColor: getColorSkin().primaryRed500,
                      onChanged: (value) {
                        setState(() {
                          _onlyAvailable = value;
                        });
                        _applyFilters(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Reset Filters Button
          TextButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _priceRange = const RangeValues(0, 50000);
                _onlyAvailable = false;
                _sortOption = null;
              });
              _refreshSets(context);
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reset Filters'),
            style: TextButton.styleFrom(
              foregroundColor: getColorSkin().primaryRed600,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfiniteScrollGrid() {
    return BlocBuilder<SetBloc, SetState>(
      builder: (context, state) {
        debugPrint(
            '[ToyScreen] Building grid with state: ${state.status.name}');

        if (state.status == SetStatus.loading && state.sets == null) {
          debugPrint('[ToyScreen] Showing loading state');
          return _buildLoading();
        }

        if (state.status == SetStatus.failure) {
          debugPrint('[ToyScreen] Showing error state: ${state.errorMessage}');
          return _buildError(state.errorMessage, context);
        }

        final sets = state.sets?.content ?? [];
        debugPrint('[ToyScreen] Raw sets count: ${sets.length}');

        // Check for null or empty sets
        if (sets.isEmpty) {
          debugPrint('[ToyScreen] Raw sets is empty');
        } else if (sets.any((set) => set.blindBox.name == null)) {
          debugPrint(
              '[ToyScreen] Warning: Some sets have null blind box names');
        }

        final filteredSets = _filterSets(sets);

        if (filteredSets.isEmpty) {
          debugPrint(
              '[ToyScreen] No sets after filtering, showing empty state');
          return _buildEmptyState();
        }

        // Calculate if we reached the end
        final reachedEnd = state.sets != null &&
            (state.sets!.totalPages - 1) <= state.currentPage;

        debugPrint(
            '[ToyScreen] Rendering grid with ${filteredSets.length} items');

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!reachedEnd &&
                !state.isLoading &&
                scrollInfo.metrics.pixels >
                    scrollInfo.metrics.maxScrollExtent - 200) {
              debugPrint(
                  '[ToyScreen] Loading more items, current page: ${state.currentPage}');
              BlocProvider.of<SetBloc>(context).add(
                LoadMoreSets(
                  pageable: openapi.Pageable(
                    page: state.currentPage + 1,
                    size: 20,
                    sort: _getSortParam(),
                  ),
                  search: _searchController.text.trim(),
                ),
              );
            }
            return false;
          },
          child: RefreshIndicator(
            color: getColorSkin().primaryRed600,
            onRefresh: () async {
              _refreshSets(context);
            },
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredSets.length + (reachedEnd ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= filteredSets.length) {
                  return _buildLoadingItem();
                }
                return _buildToyCard(filteredSets[index], index);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingItem() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildBackgroundWithBubbles() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            getColorSkin().lightOrange100,
            getColorSkin().lightYellow,
          ],
        ),
      ),
      child: Stack(
        children: List.generate(
          30,
          (index) {
            final random = Random();
            final size = random.nextDouble() * 30 + 10;
            final left =
                random.nextDouble() * MediaQuery.of(context).size.width;
            final top =
                random.nextDouble() * MediaQuery.of(context).size.height;
            final color =
                _confettiColors[random.nextInt(_confettiColors.length)]
                    .withOpacity(0.2);

            return Positioned(
              left: left,
              top: top,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 10),
      decoration: BoxDecoration(
        color: getColorSkin().lightOrange100,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon:
                    Icon(Icons.arrow_back, color: getColorSkin().primaryRed600),
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Text(
                  'Mystery Toy Sets',
                  style: TextStyle(
                    color: getColorSkin().primaryRed600,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isFilterVisible ? Icons.filter_list_off : Icons.filter_list,
                  color: getColorSkin().primaryRed600,
                ),
                onPressed: () {
                  setState(() {
                    _isFilterVisible = !_isFilterVisible;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search toy sets...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    BorderSide(color: getColorSkin().primaryRed600, width: 2),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters(context);
                      },
                    )
                  : null,
            ),
            onSubmitted: (_) => _applyFilters(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Range',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: getColorSkin().primaryRed600,
            ),
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 50000,
            divisions: 50,
            activeColor: getColorSkin().primaryRed500,
            inactiveColor: getColorSkin().lightGrey,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Only show available sets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: getColorSkin().primaryRed600,
                ),
              ),
              const Spacer(),
              Switch(
                value: _onlyAvailable,
                activeColor: getColorSkin().primaryRed500,
                onChanged: (value) {
                  setState(() {
                    _onlyAvailable = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sort By',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: getColorSkin().primaryRed600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _sortOptions.map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: _sortOption == option,
                selectedColor: getColorSkin().lightRed,
                onSelected: (selected) {
                  setState(() {
                    _sortOption = selected ? option : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: getColorSkin().primaryRed600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                _applyFilters(context);
                setState(() {
                  _isFilterVisible = false;
                });
              },
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetsList() {
    return BlocBuilder<SetBloc, SetState>(
      builder: (context, state) {
        if (state.status == SetStatus.loading && state.sets == null) {
          return _buildLoading();
        }

        if (state.status == SetStatus.failure) {
          return _buildError(state.errorMessage, context);
        }

        final sets = state.sets?.content ?? [];
        final filteredSets = _filterSets(sets);

        if (filteredSets.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: getColorSkin().primaryRed600,
          onRefresh: () async {
            _refreshSets(context);
          },
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredSets.length,
            itemBuilder: (context, index) {
              return _buildToyCard(filteredSets[index], index);
            },
          ),
        );
      },
    );
  }

  Widget _buildToyCard(SetModel set, int index) {
    final random = Random(index);
    final rotationAngle = (random.nextDouble() - 0.5) * 0.1;

    // Determine if this set has a special offer/animation (every 5th item)
    final isSpecial = index % 5 == 0;

    return GestureDetector(
      onTap: () {
        // Navigate directly to toy detail using the set ID
        debugPrint('[ToyScreen] Navigating to toy detail, setId: ${set.setId}');
        context.push('/toy/${set.setId}');
      },
      child: AnimatedBuilder(
        animation:
            isSpecial ? _bounceAnimation : const AlwaysStoppedAnimation(0),
        builder: (context, child) {
          return Transform.translate(
            offset: isSpecial
                ? Offset(0, -_bounceAnimation.value / 2)
                : Offset.zero,
            child: Transform.rotate(
              angle: rotationAngle,
              child: child,
            ),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: getColorSkin().lightGrey700,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      color: getColorSkin().lightOrange,
                      child: set.blindBox.images?.isNotEmpty == true
                          ? Image.network(
                              set.blindBox.images!.first.imageUrl ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _buildPlaceholderImage(),
                            )
                          : _buildPlaceholderImage(),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          set.blindBox.name ?? 'Mystery Box',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.toys,
                              size: 14,
                              color: getColorSkin().primaryRed500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${set.slots.where((slot) => slot.toy != null).length} toys',
                              style: TextStyle(
                                fontSize: 12,
                                color: getColorSkin().grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${set.sku.price?.toStringAsFixed(2) ?? '??'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: getColorSkin().primaryRed600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (set.sku.stock ?? 0) > 0
                                    ? getColorSkin().deepGreen
                                    : getColorSkin().grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                (set.sku.stock ?? 0) > 0
                                    ? 'In Stock'
                                    : 'Out of Stock',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Special tag
            if (isSpecial)
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: getColorSkin().primaryRed600,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    '🔥',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: getColorSkin().lightOrange100,
      child: Center(
        child: Icon(
          Icons.help_outline,
          size: 60,
          color: getColorSkin().lightOrange,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: getColorSkin().primaryRed600,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading mystery sets...',
            style: TextStyle(
              fontSize: 18,
              color: getColorSkin().darkGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String? errorMessage, BuildContext context) {
    // Log the error in more detail
    debugPrint('[ToyScreen] Error loading sets: $errorMessage');

    // Extract a more user-friendly message for display
    String displayMessage = 'Failed to load sets';

    // Check for common errors
    if (errorMessage != null) {
      if (errorMessage.contains('401')) {
        displayMessage = 'Authentication error. Please log in again.';
      } else if (errorMessage.contains('404')) {
        displayMessage = 'No toys available at the moment.';
      } else if (errorMessage.contains('500')) {
        displayMessage = 'Server error. Please try again later.';
      } else if (errorMessage.contains('timeout')) {
        displayMessage = 'Connection timeout. Please check your internet.';
      } else if (errorMessage.contains('network')) {
        displayMessage = 'Network error. Please check your connection.';
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: getColorSkin().errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            displayMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: getColorSkin().darkGrey,
            ),
          ),
          if (errorMessage != null && displayMessage != errorMessage) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: getColorSkin().lightRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Error details: ${errorMessage.substring(0, errorMessage.length > 100 ? 100 : errorMessage.length)}${errorMessage.length > 100 ? '...' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: getColorSkin().darkGrey,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _refreshSets(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: getColorSkin().primaryRed600,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: getColorSkin().darkGrey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  side: BorderSide(color: getColorSkin().lightGrey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => _debugApiCall(context),
            icon: Icon(Icons.bug_report, color: getColorSkin().primaryRed600),
            label: Text(
              'Debug API',
              style: TextStyle(
                color: getColorSkin().primaryRed600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 80,
            color: getColorSkin().grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No toy sets found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: getColorSkin().darkGrey,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Try adjusting your filters or search terms',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: getColorSkin().grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLuckyDip(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          _LuckyDipDialog(onSelectRandom: (BuildContext context) {
        // Get all sets
        final state = BlocProvider.of<SetBloc>(context).state;
        final sets = state.sets?.content ?? [];

        if (sets.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No sets available for lucky dip!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: getColorSkin().errorRed,
            ),
          );
          return;
        }

        // Pick a random set
        final random = Random();
        final randomSet = sets[random.nextInt(sets.length)];

        // Find a slot with a toy
        final toySlot = randomSet.slots
            .firstWhere((slot) => slot.toy != null, orElse: () => SlotModel());

        if (toySlot.toy?.toyId != null) {
          context.pop(); // Close dialog
          context.push('/toy/${toySlot.toy!.toyId}');
        }
      }),
    );
  }

  List<SetModel> _filterSets(List<SetModel> sets) {
    final searchTerm = _searchController.text.toLowerCase();
    debugPrint('[ToyScreen] Filtering ${sets.length} sets with:');
    debugPrint('  - Search term: "$searchTerm"');
    debugPrint('  - Price range: ${_priceRange.start} to ${_priceRange.end}');
    debugPrint('  - Only available: $_onlyAvailable');

    // Debug first few sets
    if (sets.isNotEmpty) {
      debugPrint('[ToyScreen] First set details:');
      final firstSet = sets.first;
      debugPrint('  - ID: ${firstSet.setId}');
      debugPrint('  - BlindBox: ${firstSet.blindBox.name ?? "No name"}');
      debugPrint('  - Price: ${firstSet.sku.price ?? "No price"}');
      debugPrint('  - Stock: ${firstSet.sku.stock ?? "No stock info"}');
    }

    final filtered = sets.where((set) {
      // Search filter
      if (searchTerm.isNotEmpty) {
        // Check if blindBox is null or has no name
        if (set.blindBox.name == null) {
          return false;
        }

        final matchesName =
            set.blindBox.name!.toLowerCase().contains(searchTerm);
        if (!matchesName) {
          return false;
        }
      }

      // Apply price filter if we have price information
      if (set.sku.price != null) {
        final price = set.sku.price!.toDouble();
        if (price < _priceRange.start || price > _priceRange.end) {
          return false;
        }
      }

      // Apply availability filter
      if (_onlyAvailable && (set.sku.stock ?? 0) <= 0) {
        return false;
      }

      return true;
    }).toList();

    debugPrint('[ToyScreen] After filtering: ${filtered.length} sets remain');

    // Apply sorting
    if (_sortOption != null) {
      filtered.sort((a, b) {
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

    return filtered;
  }

  void _applyFilters(BuildContext context) {
    final setBloc = BlocProvider.of<SetBloc>(context);
    final searchTerm = _searchController.text.trim();

    // For now, avoid using server-side filtering due to API issues
    // We'll filter client-side in the _filterSets method

    // Debug the API call parameters
    debugPrint(
        '[ToyScreen] Using only client-side filtering, search: $searchTerm, sort: ${_getSortParam()}');

    // Get current state and refresh with filters
    setBloc.add(
      RefreshSets(
        pageable: openapi.Pageable(
          page: 0,
          size: 50,
          sort: _getSortParam(),
        ),
        // No filter parameter to avoid API errors
        search: searchTerm,
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
        pageable: openapi.Pageable(
          page: 0,
          size: 50,
          sort: _getSortParam(),
        ),
        // No filter to avoid API errors
      ),
    );
  }

  Future<void> _debugApiCall(BuildContext context) async {
    try {
      // Show a loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Testing API connection...'),
          backgroundColor: getColorSkin().primaryRed600,
          duration: const Duration(seconds: 10),
        ),
      );

      debugPrint('\n==================================================');
      debugPrint('🔎 [ToyScreen] STARTING API DIAGNOSTICS');
      debugPrint('==================================================');

      // Get the API client from the DI container
      final api = getIt<openapi.DefaultApi>();

      // Check authentication
      debugPrint('🔐 Checking authentication...');
      final tokenService = getIt<TokenService>();
      final token = tokenService.getAccessToken();

      if (token == null || token.isEmpty) {
        debugPrint('❌ No authentication token found!');
      } else {
        debugPrint(
            '✅ Authentication token found: ${token.substring(0, min(20, token.length))}...');

        // Check if token is set in API client
        final authHeader = api.apiClient.defaultHeaderMap['Authorization'];
        if (authHeader == null || authHeader.isEmpty) {
          debugPrint('❌ No Authorization header set in API client!');
        } else {
          debugPrint(
              '✅ API client has Authorization header: ${authHeader.substring(0, min(20, authHeader.length))}...');
        }
      }

      // Create a basic pageable object
      final pageable = openapi.Pageable(
        page: 0,
        size: 10,
        sort: ['createdAt,desc'],
      );

      // Log attempt to make API call
      debugPrint('\n🔄 TEST #1: Basic API call');
      debugPrint('Attempting to call getSets API with minimal parameters...');

      // Test #1: Simple call with minimal parameters
      final response1 = await api.getSets(
        pageable: pageable,
      );

      if (response1 == null) {
        debugPrint('❌ TEST #1 FAILED: API returned null response');
      } else {
        debugPrint('✅ TEST #1 PASSED: Got ${response1.content.length} items');
        debugPrint(
            'Total: ${response1.totalElements}, Pages: ${response1.totalPages}');
      }

      // Test #2: Call with search
      if (response1 != null && response1.content.isNotEmpty) {
        debugPrint('\n🔄 TEST #2: API call with search');

        // Try to search for a term that should exist in the blindbox name
        String searchTerm = "";
        for (var setDto in response1.content) {
          if (setDto.blindBox != null &&
              setDto.blindBox!.name != null &&
              setDto.blindBox!.name!.isNotEmpty) {
            searchTerm = setDto.blindBox!.name!.split(' ').first;
            break;
          }
        }

        if (searchTerm.isNotEmpty) {
          debugPrint('Attempting to search for: "$searchTerm"');

          final response2 = await api.getSets(
            pageable: pageable,
            search: searchTerm,
          );

          if (response2 == null) {
            debugPrint('❌ TEST #2 FAILED: API returned null response');
          } else {
            debugPrint(
                '✅ TEST #2 PASSED: Got ${response2.content.length} items with search term "$searchTerm"');
          }
        } else {
          debugPrint('⚠️ Skipping search test - no sample name available');
        }
      }

      // Log test completion
      debugPrint('\n==================================================');
      debugPrint('🏁 API DIAGNOSTICS COMPLETE');
      debugPrint('==================================================\n');

      // Show success message
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'API tests completed. Check console logs for details.'),
          backgroundColor: getColorSkin().deepGreen,
          action: SnackBarAction(
            label: 'Refresh',
            textColor: Colors.white,
            onPressed: () => _refreshSets(context),
          ),
        ),
      );
    } catch (e) {
      // Log error
      debugPrint('❌ [ToyScreen] Debug API call failed: $e');

      // Show error
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('API test failed: ${e.toString()}'),
          backgroundColor: getColorSkin().errorRed,
          duration: const Duration(seconds: 8),
        ),
      );
    }
  }
}

class _LuckyDipDialog extends StatefulWidget {
  final Function(BuildContext) onSelectRandom;

  const _LuckyDipDialog({required this.onSelectRandom});

  @override
  State<_LuckyDipDialog> createState() => _LuckyDipDialogState();
}

class _LuckyDipDialogState extends State<_LuckyDipDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _spinAnimation = Tween<double>(begin: 0, end: 4 * pi).animate(
      CurvedAnimation(
        parent: _spinController,
        curve: Curves.easeOutCubic,
      ),
    );

    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onSelectRandom(context);
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _startSpin() {
    setState(() {
      _isSpinning = true;
    });
    _spinController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              getColorSkin().lightYellow,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lucky Dip!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: getColorSkin().primaryRed600,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Feeling lucky? Let us pick a random toy for you!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _spinAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _spinAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: getColorSkin().lightOrange,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: getColorSkin().primaryRed600,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: getColorSkin().primaryRed600.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.casino,
                  size: 50,
                  color: getColorSkin().primaryRed600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: getColorSkin().grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isSpinning ? null : _startSpin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().primaryRed600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _isSpinning ? 'Spinning...' : 'Spin',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
