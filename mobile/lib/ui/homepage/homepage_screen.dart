import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/blindbox_list/blindboxes_event.dart';
import 'package:mobile/main.dart';
import 'package:mobile/ui/common/bottomsheet.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/homepage/widget/filter_button.dart';
import 'package:mobile/ui/homepage/widget/new_release_products.dart';
import 'package:mobile/ui/homepage/widget/recommended_item.dart';
import 'package:mobile/ui/homepage/widget/set_section.dart';

import '../common/language_dropdown.dart';

class HomePageScreen extends StatelessWidget {
  // final AuthRepository authRepository;
  const HomePageScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePageScreen());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                            hintText: AppLocalizations.of(context)!.searchHint,
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
                    LanguageDropdown(),
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
                              AppLocalizations.of(context)!.saleContent,
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
                              child: Text(AppLocalizations.of(context)!.shopNow, style: TextStyle(color: getColorSkin().white)),
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
                const NewReleaseProducts(),
                const SetSection(),
                SizedBox(height: 10.h),

                FilterSortButtons(
                  onSortTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => SortByBottomSheet(
                        onSortSelected: (sortType) {
                          // Handle sort selection
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  onFilterTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => FilterBottomSheet(
                        onApplyFilter: (filterOptions) {
                          // Handle filter application
                        },
                      ),
                    );
                  },
                ),

                const RecommendedItems(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
