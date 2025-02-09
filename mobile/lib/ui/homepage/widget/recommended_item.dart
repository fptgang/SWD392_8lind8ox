import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildRecommendedItem() {
  return Container(
    // color: getColorSkin().primaryRed50,
    decoration: BoxDecoration(
      color: getColorSkin().primaryRed50,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: getColorSkin().primaryRed200),
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
                // color: getColorSkin().primaryRed50,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.favorite_border, color: getColorSkin().primaryRed500),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Himalayan Hood",
                style: TextStyle(fontWeight: FontWeight.bold, color: getColorSkin().primaryRed950),
              ),
              SizedBox(height: 4),
              Text("\$850.00", style: TextStyle(color: getColorSkin().primaryRed800)),
            ],
          ),
        ),
      ],
    ),
  );
}