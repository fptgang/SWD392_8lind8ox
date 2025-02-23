import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/blocs/blindbox_list/blindboxes_event.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openapi/api.dart';
import '../../../di/injection.dart';

class NewReleaseProducts extends StatelessWidget {
  const NewReleaseProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BlindBoxesBloc>()..add(GetNewReleaseBlindBoxes()),
      child: BlocBuilder<BlindBoxesBloc, BlindBoxesState>(
        builder: (context, state) {
          if (state is LoadingState) {
            if (state.isLoading && state is! DataState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null && state is! DataState) {
              return _buildErrorWidget(context, state.error!);
            }
          }

          if (state is DataState) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () => context.read<BlindBoxesBloc>().add(RefreshBlindBoxes()),
            child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, DataState state) {
    final blindBoxes = state.blindBoxes?.content;
    if (blindBoxes == null || blindBoxes.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)?.empty ?? 'No items found'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        SizedBox(height: 12.h),
        _buildProductList(context, blindBoxes),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        AppLocalizations.of(context)?.newArrival ?? "New Release Products",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: getColorSkin().black,
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<BlindBoxModel> blindBoxes) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: blindBoxes.length,
        itemBuilder: (context, index) {
          final blindBox = blindBoxes[index];
          final sku = blindBox.skus.firstWhere(
                (sku) => sku.blindBoxId == blindBox.blindBoxId,
            orElse: () => StockKeepingUnitDto(price: 0.0),
          );

          return NewReleaseProductCard(
            imageUrl: blindBox.images?.firstOrNull?.imageUrl ?? "",
            title: blindBox.name ?? "",
            price: sku.price ?? 0.0,
            onTap: () => context.push('/blind-box-detail/${blindBox.blindBoxId}'),
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
        width: 180.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: getColorSkin().backgroundColor,
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
            _buildProductImage(),
            _buildProductInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      child: Image.network(
        imageUrl,
        height: 120.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/jpg/blind_box.jpg",
            height: 120.h,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Padding(
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
    );
  }
}