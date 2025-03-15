import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/base/common/widgets/error.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindboxes_event.dart';
import 'package:mobile/feature/home/widget/section_header.dart';

import 'new_release_card.dart';

class NewReleaseProducts extends StatelessWidget {
  const NewReleaseProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final blindBoxBloc = context.read<BlindBoxesListBloc>();
    return BlocBuilder<BlindBoxesListBloc, BlindBoxesState>(
      bloc: blindBoxBloc,
      builder: (context, state) {
        if (state is LoadingState) {
          if (state.isLoading && state is! DataState) {
            return _buildLoadingIndicator();
          }
          if (state.error != null && state is! DataState) {
            return CommonErrorWidget(
              error: state.error!,
              onRetry: () =>
                  context.read<BlindBoxesListBloc>().add(RefreshBlindBoxes()),
            );
          }
        }
        if (state is DataState) {
          return _buildContent(context, state);
        }
        return _buildEmptyState(context);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 200.h,
      child: Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(getColorSkin().primaryRed600),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48.sp,
              color: getColorSkin().grey,
            ),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)?.empty ?? 'No items found',
              style: TextStyle(
                color: getColorSkin().grey,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DataState state) {
    final blindBoxes = state.blindBoxes?.content;
    if (blindBoxes == null || blindBoxes.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
            title: AppLocalizations.of(context)?.newArrival ??
                "New Release Products",
            onSeeAllPressed: () {
              context.push('/blind-boxes');
            }),
        SizedBox(height: 12.h),
        _buildProductList(context, blindBoxes),
      ],
    );
  }

  Widget _buildProductList(
      BuildContext context, List<BlindBoxModel> blindBoxes) {
    return SizedBox(
      height: 220.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: blindBoxes.length,
        itemBuilder: (context, index) {
          final blindBox = blindBoxes[index];

          StockKeepingUnitModel? sku;
          if (blindBox.skus != null && blindBox.skus!.isNotEmpty) {
            sku = blindBox.skus!.first;
          }

          final imageUrl = blindBox.images != null &&
                  blindBox.images!.isNotEmpty &&
                  blindBox.images!.first.imageUrl != null
              ? blindBox.images!.first.imageUrl!
              : "";

          return NewReleaseProductCard(
            imageUrl: imageUrl,
            title: blindBox.name ?? 'Unnamed Product',
            price: sku?.price ?? 0.0,
            onTap: () {
              if (blindBox.blindBoxId != null) {
                context.push('/blind-box-detail/${blindBox.blindBoxId}');
              }
            },
          );
        },
      ),
    );
  }
}
