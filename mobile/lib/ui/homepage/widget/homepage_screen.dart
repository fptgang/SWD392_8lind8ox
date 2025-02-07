import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/enum/enum.dart';
import 'package:mobile/ui/blind_box_detail/widget/blind_box_detail_screen.dart';
import 'package:mobile/ui/cart/widget/cart_screen.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/homepage/widget/category_item.dart';
import 'package:mobile/ui/homepage/widget/recommended_item.dart';
import 'package:mobile/ui/login/login_screen.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../account/account_screen.dart';

class HomePageScreen extends StatelessWidget {
  // final AuthRepository authRepository;
  const HomePageScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePageScreen());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: getColorSkin().lightGrey200,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              border: InputBorder.none,
                              hintText: "Search here...",
                              hintStyle: TextStyle(color: getColorSkin().black),
                              // prefixIcon: Icon(Icons.search, color: getColorSkin().accentColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: getColorSkin().primaryRed600,
                        child: Icon(Icons.search,
                            color: getColorSkin().backgroundColor),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () {
                          final authStatus = context.read<AuthenticationBloc>().state.status;
                          debugPrint("authStatus: $authStatus");
                          if (authStatus == AuthenticationStatus.authenticated) {
                            context.push('/account');
                          } else if (authStatus == AuthenticationStatus.unauthenticated || authStatus == AuthenticationStatus.unknown) {
                            context.push('/login');
                          }
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: getColorSkin().lightGrey,
                          child: Icon(Icons.person, color: getColorSkin().black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: getColorSkin().primaryRed50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                "Get Your Special Sale Up to 50%",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: getColorSkin().primaryRed900,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: getColorSkin().primaryRed600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text("Shop Now", style: TextStyle(color: getColorSkin().white)),
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
                            context.push('/blind-box-detail');
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
