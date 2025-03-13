import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/ui/core/theme/theme.dart';

class ProductItem extends StatelessWidget {
  final SetModel set;

  const ProductItem({
    super.key,
    required this.set,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // return ClipRRect(
    //   borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
    //   child: set.images.isNotEmpty
    //       ? Image.network(
    //     set.images.first.imageUrl ?? '',
    //     height: 140.h,
    //     width: double.infinity,
    //     fit: BoxFit.cover,
    //     errorBuilder: (_, __, ___) => _buildErrorImage(),
    //   )
    //       : _buildErrorImage(),
    // );
    return Container(
      height: 140.h,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: 40.r,
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      height: 140.h,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: 40.r,
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            set.blindBox.name ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: getColorSkin().black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '\$${set.sku.price?.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12.sp,
              color: getColorSkin().primaryRed800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}