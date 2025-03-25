import 'package:flutter/material.dart';
import 'package:mobile/data/models/blindbox_model.dart';

class BlindBoxCard extends StatelessWidget {
  final BlindBoxModel blindBox;
  final VoidCallback? onTap;

  const BlindBoxCard({
    Key? key,
    required this.blindBox,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 220, // Fixed height to prevent overflow
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                child: _buildImageWithErrorHandling(context),
              ),
            ),
            Expanded(
              // Use Expanded to prevent overflow
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blindBox.name ?? 'Unnamed BlindBox',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (blindBox.brand != null)
                      Text(
                        blindBox.brand?.name ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const Spacer(),
                    if (blindBox.skus != null && blindBox.skus!.isNotEmpty)
                      Text(
                        '${blindBox.skus!.first.price?.toStringAsFixed(2) ?? '-'} VND',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithErrorHandling(BuildContext context) {
    final String? imageUrl =
        blindBox.images != null && blindBox.images!.isNotEmpty
            ? blindBox.images!.first.imageUrl
            : null;

    if (imageUrl == null || imageUrl.isEmpty) {
      return const Center(
        child: Icon(Icons.inventory_2, size: 40, color: Colors.grey),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      // Error handling for image loading
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
    );
  }
}
