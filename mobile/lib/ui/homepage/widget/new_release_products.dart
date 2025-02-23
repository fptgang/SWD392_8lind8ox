import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/blocs/blindbox_list/blindboxes_event.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/ui/common/error.dart';
import 'package:mobile/ui/common/header.dart';
import 'package:openapi/api.dart';

import 'new_release_card.dart';

class NewReleaseProducts extends StatelessWidget {
  const NewReleaseProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final blindBoxBloc = context.read<BlindBoxesBloc>();
    return BlocBuilder<BlindBoxesBloc, BlindBoxesState>(
      bloc: blindBoxBloc,
      builder: (context, state) {
        if (state is LoadingState) {
          if (state.isLoading && state is! DataState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state is! DataState) {
            return CommonErrorWidget(
              error: state.error!,
              onRetry: () =>
                  context.read<BlindBoxesBloc>().add(RefreshBlindBoxes()),
            );
          }
        }
        if (state is DataState) {
          return _buildContent(context, state);
        }
        return const SizedBox.shrink();
      },
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
        SectionHeader(
            title: AppLocalizations.of(context)?.newArrival ?? "New Release Products",
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
            onTap: () =>
                context.push('/blind-box-detail/${blindBox.blindBoxId}'),
          );
        },
      ),
    );
  }
}


