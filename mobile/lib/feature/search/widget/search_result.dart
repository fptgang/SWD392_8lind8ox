import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart' show parse;
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_event.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/feature/search/blocs/search_bloc.dart';
import 'package:mobile/feature/search/blocs/search_event.dart';
import 'package:mobile/feature/search/blocs/search_state.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger load more when we're at the bottom of the list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Check current state to avoid duplicate calls
      final searchState = context.read<SearchBloc>().state;
      if (searchState is SearchDataState &&
          !searchState.isLoadingMore &&
          !searchState.hasReachedEnd) {
        context.read<SearchBloc>().add(LoadMoreResults());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoadingState && state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is SearchDataState) {
          final blindBoxes = state.searchResults?.content;
          if (blindBoxes == null || blindBoxes.isEmpty) {
            return _buildEmptyState();
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Results for "${state.searchQuery}"',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildFilterBar(context, state),
                ListView.separated(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: blindBoxes.length + (state.isLoadingMore ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == blindBoxes.length) {
                      return _buildLoadingMoreIndicator();
                    }
                    return _buildBlindBoxItem(context, blindBoxes[index]);
                  },
                ),
              ],
            ),
          );
        }

        if (state is SearchLoadingState && state.error != null) {
          return _buildErrorState(state.error!);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term or filter',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error loading results',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final searchBloc = context.read<SearchBloc>();
              if (searchBloc.state is SearchDataState) {
                final query = (searchBloc.state as SearchDataState).searchQuery;
                if (query != null && query.isNotEmpty) {
                  searchBloc.add(SubmitSearch(query));
                }
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, SearchDataState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(context, 'Newest', 'createdAt,desc', state.filter),
          _buildFilterChip(context, 'Oldest', 'createdAt,asc', state.filter),
          _buildFilterChip(context, 'Name A-Z', 'name,asc', state.filter),
          _buildFilterChip(context, 'Name Z-A', 'name,desc', state.filter),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label,
      String filterValue, String? currentFilter) {
    final isSelected = currentFilter == filterValue;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            context.read<SearchBloc>().add(ApplySearchFilter(filterValue));
          } else {
            context.read<SearchBloc>().add(ApplySearchFilter(''));
          }
        },
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildBlindBoxItem(BuildContext context, BlindBoxModel box) {
    final cleanName = _parseHtmlString(box.name ?? 'Unknown Box');
    final cleanDescription = _parseHtmlString(box.description ?? '');

    return InkWell(
      onTap: () => context.push('/blind-box-detail/${box.blindBoxId}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemImage(box),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleanName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),

                  // Conditionally add brand name only if it exists
                  if (box.brand?.name != null &&
                      box.brand!.name!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _parseHtmlString(box.brand!.name!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],

                  // Conditionally add description only if it's not empty
                  if (cleanDescription.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      cleanDescription,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Conditionally build specs row
                  if (_hasSpecsInfo(box)) ...[
                    const SizedBox(height: 8),
                    _buildSpecsRow(context, box),
                  ],

                  // Conditionally add price only if it exists
                  if (box.skus != null &&
                      box.skus!.isNotEmpty &&
                      box.skus!.first.price != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${box.skus!.first.price!.toStringAsFixed(2)} USD',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasSpecsInfo(BlindBoxModel box) {
    final description = box.description ?? '';
    return description.contains('Material:') ||
        description.contains('Height:') ||
        description.contains('Release Date:');
  }

  Widget _buildSpecsRow(BuildContext context, BlindBoxModel box) {
    final description = box.description ?? '';
    List<String> specs = [];

    final materialMatch =
        RegExp(r'Material:\s*([\w\/]+)').firstMatch(description);
    if (materialMatch != null) {
      specs.add('Material: ${materialMatch.group(1)!}');
    }

    final heightMatch =
        RegExp(r'Height:\s*([\d\.\-\s]+inches)').firstMatch(description);
    if (heightMatch != null) {
      specs.add('Height: ${heightMatch.group(1)!}');
    }

    final releaseDateMatch =
        RegExp(r'Release Date:\s*([\w\s,\.]+\d{4})').firstMatch(description);
    if (releaseDateMatch != null) {
      specs.add('Released: ${releaseDateMatch.group(1)!}');
    }

    // Only build the Wrap if there are specs
    return specs.isNotEmpty
        ? Wrap(
            spacing: 16,
            children:
                specs.map((spec) => _buildSpecChip(context, spec)).toList(),
          )
        : const SizedBox.shrink();
  }

  Widget _buildSpecChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontSize: 10,
            ),
      ),
    );
  }

  Widget _buildItemImage(BlindBoxModel box) {
    String? imageUrl;

    if (box.description != null && box.description!.contains('<img')) {
      final imgMatch =
          RegExp(r'<img src="([^"]+)"').firstMatch(box.description!);
      if (imgMatch != null) {
        imageUrl = imgMatch.group(1);
      }
    }

    if (imageUrl == null && box.images != null && box.images!.isNotEmpty) {
      imageUrl = box.images!.first.imageUrl;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 80,
        height: 80,
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[200],
                child: Icon(Icons.image, color: Colors.grey[400]),
              ),
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement!.text;
    return parsedString;
  }
}
