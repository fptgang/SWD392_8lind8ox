import 'package:flutter/material.dart';
import 'package:mobile/base/theme/theme.dart';

class OrderItemsSection extends StatelessWidget {
  const OrderItemsSection({
    super.key,
    this.items = const [],
  });

  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    // Example data - in a real app, this would come from cart provider
    final demoItems = [
      {
        'id': 1,
        'name': 'Product 1',
        'skuName': 'Variant A',
        'price': 49.99,
        'originalPrice': 59.99,
        'quantity': 1,
        'imageUrl': 'https://placehold.co/300x300',
      },
      {
        'id': 2,
        'name': 'Product 2',
        'skuName': 'Variant B',
        'price': 29.99,
        'originalPrice': 29.99,
        'quantity': 2,
        'imageUrl': 'https://placehold.co/300x300',
      },
    ];

    final displayItems = items.isNotEmpty ? items : demoItems;

    return Card(
      color: getColorSkin().white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Items',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to cart
                    // context.push('/cart');
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Cart'),
                ),
              ],
            ),
            const Divider(),
            ...displayItems.map((item) => _buildOrderItem(context, item)),
          ],
        ),
      ),
    );
  }

  // Check if URL is an image or not
  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    // Check for common video extensions
    final lowerCaseUrl = url.toLowerCase();
    final isVideo = lowerCaseUrl.endsWith('.mp4') ||
        lowerCaseUrl.endsWith('.mov') ||
        lowerCaseUrl.endsWith('.avi') ||
        lowerCaseUrl.endsWith('.wmv') ||
        lowerCaseUrl.endsWith('.webm');

    // If it's a video, return true to show video thumbnail
    return isVideo;
  }

  Widget _buildOrderItem(BuildContext context, dynamic item) {
    final hasDiscount = (item['originalPrice'] ?? 0.0) > (item['price'] ?? 0.0);
    final discountPercentage = hasDiscount
        ? ((1 - (item['price'] / item['originalPrice'])) * 100).round()
        : 0;

    // Get image URL and validate it
    final imageUrl = item['imageUrl'] ?? 'https://placehold.co/300x300';
    final isVideo = _isValidImageUrl(imageUrl);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image or video thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: isVideo
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        // Video thumbnail
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.video_file, size: 20),
                            );
                          },
                        ),
                        // Video overlay
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported, size: 20),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Product',
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item['skuName'] != null)
                  Text(
                    'Variant: ${item['skuName']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\$${item['originalPrice']?.toStringAsFixed(2) ?? '0.00'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Text(
                          '$discountPercentage% OFF',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Quantity and total
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${((item['price'] ?? 0.0) * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${item['quantity'] ?? 1} × \$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
