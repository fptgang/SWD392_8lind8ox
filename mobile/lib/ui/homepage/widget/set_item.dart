import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/data/models/set_model.dart';

class SetItem extends StatelessWidget {
  final SetModel set;
  final VoidCallback? onTap;

  const SetItem({
    super.key,
    required this.set,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          _buildAvatar(),
          SizedBox(height: 8.h),
          _buildSetInfo(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 30.r,
      backgroundColor: getColorSkin().primaryRed50,
      // child: ClipOval(
      //   child: set.images.isNotEmpty
      //       ? Image.network(
      //     set.images.first.imageUrl ?? '',
      //     width: 30.w,
      //     height: 30.h,
      //     fit: BoxFit.cover,
      //     errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
      //   )
      //       : _buildErrorImage(),
      // ),
    );
  }

  Widget _buildErrorImage() {
    return Icon(
      Icons.image_not_supported,
      size: 30.r,
      color: getColorSkin().primaryRed200,
    );
  }

  Widget _buildSetInfo() {
    return Column(
      children: [
        Text(
          set.setId.toString(),
          style: TextStyle(
            fontSize: 14.sp,
            color: getColorSkin().primaryRed950,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          '\$${set.sku.price?.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 12.sp,
            color: getColorSkin().primaryRed600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
