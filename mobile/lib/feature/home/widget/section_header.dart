import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? seeAllStyle;
  final bool showSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAllPressed,
    this.padding,
    this.titleStyle,
    this.seeAllStyle,
    this.showSeeAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ??
                TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().black,
                ),
          ),
          if (showSeeAll) ...[
            TextButton(
              onPressed: onSeeAllPressed,
              child: Text(
                'See All',
                style: seeAllStyle ??
                    TextStyle(
                      fontSize: 14.sp,
                      color: getColorSkin().primaryRed600,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
