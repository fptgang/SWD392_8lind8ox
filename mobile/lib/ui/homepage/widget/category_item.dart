import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/core/theme/theme.dart';

Widget buildCategoryItem(String title, String iconAsset) {
  return Column(
    children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: getColorSkin().lightGrey200,
        child: Image.asset(
          iconAsset,
          width: 30,
          height: 30,
        ),
      ),
      SizedBox(height: 8.h),
      Text(title, style: const TextStyle(fontSize: 14)),
    ],
  );
}