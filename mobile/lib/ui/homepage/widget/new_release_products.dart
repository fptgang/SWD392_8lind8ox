

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/cubit/blindbox_list_cubit/blindbox_list_state.dart';
import 'package:mobile/ui/core/theme/theme.dart';

import '../../../cubit/blindbox_list_cubit/blindbox_list_cubit.dart';
import '../../../di/injection.dart';


class NewReleaseProducts extends StatelessWidget {
  const NewReleaseProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final blindBoxesCubit = getIt<BlindBoxesCubit>();

    return BlocProvider(
      create: (context) => blindBoxesCubit..getNewReleaseBlindBoxes(),
      child: BlocBuilder<BlindBoxesCubit, BlindBoxesState>(
        builder: (context, state) {
          if (state.isLoading == true && (state.blindBoxes?.content.isEmpty ?? true)) {
            return const Center(child: CircularProgressIndicator());
          }

          if ((state.error?.isNotEmpty ?? false) && (state.blindBoxes?.content.isEmpty ?? true)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  ElevatedButton(
                    onPressed: () => context.read<BlindBoxesCubit>().refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final blindBoxes = state.blindBoxes?.content ?? [];

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
                  itemCount: blindBoxes.length,
                  itemBuilder: (context, index) {
                    return NewReleaseProductCard(
                      imageUrl: blindBoxes[index].images[0].imageUrl ?? "",
                      title: blindBoxes[index].name ?? "Blind Box",
                      price: blindBoxes[index].skus.firstWhere((sku) => sku.blindBoxId == blindBoxes[index].blindBoxId).price ?? 0.0,
                      onTap: () {
                        context.push('/blind-box-detail/${blindBoxes[index].blindBoxId}');
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
    ),
    );
  }
}
class NewReleaseProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final VoidCallback onTap;

  const NewReleaseProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
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
              child: Image.network(
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
                    "\$${price.toStringAsFixed(2)}",
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
