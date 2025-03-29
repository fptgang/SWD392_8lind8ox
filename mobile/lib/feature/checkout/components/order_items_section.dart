import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/base/theme/theme.dart';

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
    final colorSkin = getColorSkin();

    if (items.isEmpty) {
      return _buildEmptyItems(context);
    }

    return Card(
      color: getColorSkin().white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorSkin.lightGrey300, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              colorSkin.white,
              colorSkin.lightGrey100,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: colorSkin.primaryRed650,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Order Items',
                      style: TextStyle(
                        fontSize: 18,
                        color: colorSkin.primaryRed800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onEditCart ?? () => context.pop(),
                  icon: Icon(Icons.edit, color: colorSkin.primaryRed650),
                  label: Text('Edit Cart',
                      style: TextStyle(color: colorSkin.primaryRed650)),
                  style: TextButton.styleFrom(
                    backgroundColor: colorSkin.primaryRed650.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(
                color: colorSkin.lightGrey300,
                thickness: 1,
              ),
            ),
            ...items.map((item) => _buildOrderItem(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyItems(BuildContext context) {
    final colorSkin = getColorSkin();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorSkin.lightGrey300, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorSkin.white,
              colorSkin.lightGrey100,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorSkin.lightGrey200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 56,
                  color: colorSkin.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No items in cart',
                style: TextStyle(
                  fontSize: 18,
                  color: colorSkin.darkGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add some items to your cart to continue',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorSkin.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go('/main'),
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Continue Shopping'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSkin.primaryRed650,
                  foregroundColor: colorSkin.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
    final colorSkin = getColorSkin();
    final hasDiscount = (item['originalPrice'] ?? 0.0) > (item['price'] ?? 0.0);
    final discountPercentage = hasDiscount
        ? ((1 - (item['price'] / item['originalPrice'])) * 100).round()
        : 0;

    // Get image URL and validate it
    final imageUrl = item['imageUrl'] ?? 'https://placehold.co/300x300';
    final isVideo = _isValidImageUrl(imageUrl);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorSkin.white,
        boxShadow: [
          BoxShadow(
            color: colorSkin.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: colorSkin.lightGrey300),
      ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorSkin.darkGrey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item['skuName'] != null &&
                    item['skuName'].toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Variant: ${item['skuName']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorSkin.grey,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '\$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: colorSkin.primaryRed650,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\$${item['originalPrice']?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: colorSkin.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorSkin.warningRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: colorSkin.warningRed.withOpacity(0.3)),
                        ),
                        child: Text(
                          '$discountPercentage% OFF',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorSkin.warningRed,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${item['quantity'] ?? 1}',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorSkin.grey,
                  ),
                ),
              ],
            ),
          ),
          // Total
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${((item['price'] ?? 0.0) * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: colorSkin.primaryRed800,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorSkin.primaryRed650.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${item['quantity'] ?? 1} × \$${item['price']?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: colorSkin.primaryRed650,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
