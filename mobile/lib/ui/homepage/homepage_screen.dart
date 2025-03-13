import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/cart_cubit/cart_state.dart';
import 'package:mobile/ui/common/bottomsheet.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/homepage/widget/filter_button.dart';
import 'package:mobile/ui/homepage/widget/new_release_products.dart';
import 'package:mobile/ui/homepage/widget/recommended_item.dart';
import 'package:badges/badges.dart' as badges;

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePageScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Add refresh functionality here
            await Future.delayed(const Duration(seconds: 1));
            return;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(context),
                  SizedBox(height: 20.h),
                  _buildPromoBanner(context),
                  SizedBox(height: 24.h),
                  const NewReleaseProducts(),
                  SizedBox(height: 16.h),
                  _buildFilterSection(context),
                  SizedBox(height: 16.h),
                  const RecommendedItems(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: getColorSkin().lightGrey200,
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onTap: () {
                context.push('/main/search');
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 10.h),
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.searchHint,
                hintStyle: TextStyle(
                  color: getColorSkin().grey,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        CircleAvatar(
          radius: 22.r,
          backgroundColor: getColorSkin().primaryRed600,
          child: Icon(Icons.search,
              color: getColorSkin().backgroundColor),
        ),
        SizedBox(width: 16.w),
        // LanguageDropdown(),
        BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final int itemCount = cartState.items.fold(
                  0, (sum, item) => sum + item.quantity);

              return badges.Badge(
                showBadge: itemCount > 0,
                badgeContent: Text(
                  itemCount.toString(),
                  style: TextStyle(
                    color: getColorSkin().white,
                    fontSize: 10,
                  ),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: getColorSkin().primaryRed650,
                  padding: const EdgeInsets.all(5),
                ),
                position: badges.BadgePosition.topEnd(top: 0, end: 0),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: getColorSkin().black),
                  onPressed: () => context.push('/cart'),
                ),
              );
            }
        ),

      ],
    );
  }
  
  Widget _buildPromoBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w.h),
      decoration: BoxDecoration(
        color: getColorSkin().primaryRed50,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: getColorSkin().primaryRed100.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
                    fontSize: 16.sp,
                    color: getColorSkin().primaryRed900,
                  ),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () {
                    context.push('/shopping');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorSkin().primaryRed600,
                    foregroundColor: getColorSkin().white,
                    elevation: 2,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.shopNow,
                    style: TextStyle(
                      color: getColorSkin().white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: getColorSkin().primaryRed100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer,
              color: getColorSkin().primaryRed600,
              size: 32.sp,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.filterBy ?? 'Filter By',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: getColorSkin().black,
          ),
        ),
        SizedBox(height: 8.h),
        FilterSortButtons(
          onSortTap: () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              builder: (context) => FilterBottomSheet(
                onApplyFilter: (filterOptions) {
                  // Handle filter application
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
