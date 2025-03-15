import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart' show parse;
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_state.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlindBoxesListBloc, BlindBoxesState>(
      builder: (context, state) {
        if (state is LoadingState && state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is DataState) {
          final blindBoxes = state.blindBoxes?.content;
          if (blindBoxes == null || blindBoxes.isEmpty) {
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
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: blindBoxes.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildBlindBoxItem(context, blindBoxes[index]);
            },
          );
        }

        if (state is LoadingState && state.error != null) {
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
                  state.error!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
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
    try {
      final document = parse(htmlString);
      return document.body?.text ?? htmlString;
    } catch (e) {
      // If parsing fails, do basic cleanup
      return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
    }
  }
}
