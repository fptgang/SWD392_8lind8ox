

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/core/theme/theme.dart';


class NewReleaseProducts extends StatelessWidget {
  const NewReleaseProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> newReleases = [
      {
        "image": "assets/jpg/blind_box.jpg",
        "title": "Labubu Special Edition",
        "subtitle": "8 Variants + 1 Hidden",
      },
      {
        "image": "assets/jpg/blind_box.jpg",
        "title": "Dimoo Fairy Tale",
        "subtitle": "6 Variants + 1 Hidden",
      },
      {
        "image": "assets/jpg/blind_box.jpg",
        "title": "Molly Beach Set",
        "subtitle": "Limited Edition",
      },
      {
        "image": "assets/jpg/blind_box.jpg",
        "title": "Bobo & Coco",
        "subtitle": "New Release",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "New Release Products",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: getColorSkin().black,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: newReleases.length,
            itemBuilder: (context, index) {
              final product = newReleases[index];
              return NewReleaseProductCard(
                imageUrl: product["image"]!,
                title: product["title"]!,
                subtitle: product["subtitle"]!,
                onTap: () {
                  // Handle product tap
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
class NewReleaseProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const NewReleaseProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180.w, // Card Width
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
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
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Image.asset(
                imageUrl,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: getColorSkin().black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: getColorSkin().grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
