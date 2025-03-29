import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderItemsSection extends StatelessWidget {
  const OrderItemsSection({
    super.key,
    required this.items,
    this.onEditCart,
  });

  final List<dynamic> items;
  final VoidCallback? onEditCart;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyItems(context);
    }

    return Card(
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
                  onPressed: onEditCart ?? () => context.pop(),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Cart'),
                ),
              ],
            ),
            const Divider(),
            ...items.map((item) => _buildOrderItem(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyItems(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No items in cart',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/main'),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Check if URL is an image or not
  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    // Check for common video extensions that might be misused as image sources
    final lowerCaseUrl = url.toLowerCase();
    return !lowerCaseUrl.endsWith('.mp4') &&
        !lowerCaseUrl.endsWith('.mov') &&
        !lowerCaseUrl.endsWith('.avi') &&
        !lowerCaseUrl.endsWith('.wmv') &&
        !lowerCaseUrl.endsWith('.webm');
  }

  Widget _buildOrderItem(BuildContext context, dynamic item) {
    final hasDiscount = (item['originalPrice'] ?? 0.0) > (item['price'] ?? 0.0);
    final discountPercentage = hasDiscount
        ? ((1 - (item['price'] / item['originalPrice'])) * 100).round()
        : 0;

    // Get image URL and validate it
    final imageUrl = item['imageUrl'] ?? 'https://placehold.co/300x300';
    final isValidImage = _isValidImageUrl(imageUrl);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isValidImage
                ? Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 20),
                        ),
                      );
                    },
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.video_file, size: 20),
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
                if (item['skuName'] != null &&
                    item['skuName'].toString().isNotEmpty)
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
