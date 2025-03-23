import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';

class CartItemWidget extends StatelessWidget {
  final dynamic cartItem;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;
  final bool isSelected;
  final Function(bool?) onSelectionChanged;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onQuantityChanged,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = cartItem.image ?? '';
    final String productName = cartItem.productName ?? 'Unknown Product';
    final double price = cartItem.price ?? 0.0;
    final int quantity = cartItem.quantity ?? 1;
    final double total = price * quantity;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: getColorSkin().white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: getColorSkin().shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selection checkbox
              Padding(
                padding: EdgeInsets.only(top: 8.r, right: 8.r),
                child: SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectionChanged,
                    activeColor: getColorSkin().primaryRed650,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
              
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 80.w,
                  height: 80.w,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: getColorSkin().lightGrey200,
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: getColorSkin().lightGrey200,
                          child: const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 12.w),

              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: getColorSkin().darkGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: getColorSkin().primaryRed800,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity controls
                        Row(
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onPressed: quantity > 1
                                  ? () => onQuantityChanged(quantity - 1)
                                  : null,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onPressed: () => onQuantityChanged(quantity + 1),
                            ),
                          ],
                        ),

                        // Total
                        Text(
                          'Total: \$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: getColorSkin().darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Remove button
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.delete_outline,
                color: getColorSkin().warningRed,
                size: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null
            ? getColorSkin().lightGrey100
            : getColorSkin().lightGrey300,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(4.r),
          child: Icon(
            icon,
            size: 16.sp,
            color: onPressed != null
                ? getColorSkin().darkGrey
                : getColorSkin().grey,
          ),
        ),
      ),
    );
  }
}
