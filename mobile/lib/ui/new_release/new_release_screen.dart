import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/new_release/widget/drawer.dart';

import '../../cubit/category_cubit/category_cubit.dart';

class NewReleasesScreen extends StatelessWidget {
  final List<Map<String, String>> allProducts = [
    {"image": "assets/jpg/blind_box.jpg", "title": "Skullpanda Series", "price": "\$69", "category": "Skullpanda"},
    {"image": "assets/jpg/blind_box.jpg", "title": "Mega Space Molly", "price": "\$1299", "category": "Molly"},
    {"image": "assets/jpg/blind_box.jpg", "title": "Dimoo Fantasy", "price": "\$69", "category": "Dimoo"},
    {"image": "assets/jpg/blind_box.jpg", "title": "The Monsters Secret", "price": "\$199", "category": "Labubu"},
    {"image": "assets/jpg/blind_box.jpg", "title": "Ted2 Collectible", "price": "\$59", "category": "Storage"},
    {"image": "assets/jpg/blind_box.jpg", "title": "Fox Demon Red", "price": "\$89", "category": "Phone Stands"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit(),
      child: Scaffold(
        drawer: CategoryDrawer(),
        appBar: AppBar(
          backgroundColor: getColorSkin().primaryRed650,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: getColorSkin().white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            "New Releases",
            style: TextStyle(color: getColorSkin().white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CategoryCubit, String>(
                builder: (context, selectedCategory) {
                  // Filter products based on category
                  final filteredProducts = allProducts
                      .where((product) => selectedCategory == "Popular" || product["category"] == selectedCategory)
                      .toList();

                  return Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.only(top: 8.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return buildProductItem(
                          product["image"]!,
                          product["title"]!,
                          product["price"]!,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductItem(String image, String title, String price) {
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
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: Image.asset(
              image,
              height: 140.h,
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
                  price,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: getColorSkin().primaryRed800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
