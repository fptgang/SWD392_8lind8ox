import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/auth/widget/auth_tab.dart';
import 'package:mobile/ui/blind_box_detail/widget/blind_box_detail_screen.dart';
import 'package:mobile/ui/cart/widget/cart_screen.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/homepage/widget/category_item.dart';
import 'package:mobile/ui/homepage/widget/recommended_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/ui/login/login_screen.dart';

class HomePageScreen extends StatelessWidget {
  // final AuthRepository authRepository;
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: getColorSkin().backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                            color: getColorSkin().lightGrey200,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              border: InputBorder.none,
                              hintText: "Search here...",
                              // prefixIcon: Icon(Icons.search, color: getColorSkin().accentColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: getColorSkin().accentColor,
                        child: Icon(Icons.search,
                            color: getColorSkin().backgroundColor),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartScreen()));
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: getColorSkin().lightGrey,
                          child: Icon(Icons.add_shopping_cart,
                              color: getColorSkin().black),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: getColorSkin().lightGrey,
                          child:
                          Icon(Icons.person, color: getColorSkin().black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: getColorSkin().yellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Get Your Special Sale Up to 50%",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: getColorSkin().black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Shop Now", style: TextStyle(color: getColorSkin().backgroundColor)),
                              ),
                            ],
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/discount.svg",
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Category Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select by Category",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text("See all",
                              style: TextStyle(color: getColorSkin().black))),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return buildCategoryItem(
                            category["title"]!, category["iconAsset"]!);
                      },
                      separatorBuilder: (context, index) => SizedBox(width: 16.w),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select by Case",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text("See all",
                              style: TextStyle(color: getColorSkin().black))),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return buildCategoryItem(
                            category["title"]!, category["iconAsset"]!);
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 16.w),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recommended for You",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text("See all",
                              style: TextStyle(color: getColorSkin().black))),
                    ],
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: 4,
                    // Adjust the count as needed
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const ProductDetailScreen();
                              },
                            ));
                          },
                          child: buildRecommendedItem());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



final List<Map<String, String>> categories = [
  {"title": "Labubu", "iconAsset": "assets/jpg/blind_box.jpg"},
  {"title": "Babythree", "iconAsset": "assets/jpg/blind_box.jpg"},
  {"title": "Cinamoroll", "iconAsset": "assets/jpg/blind_box.jpg"},
  {"title": "Unicorn", "iconAsset": "assets/jpg/blind_box.jpg"},
  {"title": "Kuromi", "iconAsset": "assets/jpg/blind_box.jpg"},
];
