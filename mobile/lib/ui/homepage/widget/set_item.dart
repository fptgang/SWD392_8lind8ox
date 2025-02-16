import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/core/theme/theme.dart';

Widget buildSetItem(String setName, String image, double price) {
  return Column(
    children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: getColorSkin().primaryRed50,
        child: Image.network(
          image,
          width: 30,
          height: 30,
        ),
      ),
      SizedBox(height: 8.h),
      Text(setName, style: TextStyle(fontSize: 14, color: getColorSkin().primaryRed950)),
      SizedBox(height: 4.h),
      Text('\$${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, color: getColorSkin().primaryRed600)),
    ],
  );
}