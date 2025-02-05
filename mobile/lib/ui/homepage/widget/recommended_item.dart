import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildRecommendedItem() {
  return Container(
    // height: 130.h,
    decoration: BoxDecoration(
      color: getColorSkin().lightGrey100,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                "assets/jpg/blind_box.jpg",
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.favorite_border, color: getColorSkin().backgroundColor),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Himalayan Hood",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("\$850.00", style: TextStyle(color: getColorSkin().grey)),
            ],
          ),
        ),
      ],
    ),
  );
}