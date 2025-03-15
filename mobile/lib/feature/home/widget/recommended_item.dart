import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/common/widgets/error.dart';
import 'package:mobile/base/common/widgets/no_data.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/feature/home/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/feature/home/widget/section_header.dart';

import '../../../data/models/blindbox_model.dart';
import '../blocs/blindbox_list/blindboxes_event.dart';

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({super.key});

  @override
  Widget build(BuildContext context) {
    final blindBoxBloc = getIt<BlindBoxesListBloc>();

    return BlocBuilder<BlindBoxesListBloc, BlindBoxesState>(
      bloc: blindBoxBloc,
      builder: (context, state) {
        if (state is LoadingState) {
          if (state.isLoading && state is! DataState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state is! DataState) {
            return CommonErrorWidget(
              error: state.error!,
              onRetry: () => blindBoxBloc.add(RefreshBlindBoxes()),
            );
          }
        }

        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(context),
        _buildGridView(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return SectionHeader(
      title: AppLocalizations.of(context)?.recommended ?? "Recommended",
      onSeeAllPressed: () => context.push('/blind-boxes'),
    );
  }

  Widget _buildGridView(BuildContext context) {
    final blindBoxBloc = context.read<BlindBoxesListBloc>();

    return Container(
      height: 550.h,
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: PagedGridView<int, BlindBoxModel>(
        physics: const NeverScrollableScrollPhysics(),
        pagingController: blindBoxBloc.pagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        builderDelegate: PagedChildBuilderDelegate<BlindBoxModel>(
          itemBuilder: (context, blindBox, index) =>
              _buildGridItem(context, blindBox),
          firstPageErrorIndicatorBuilder: (context) => CommonErrorWidget(
            error: 'Error',
            onRetry: () => blindBoxBloc.add(RefreshBlindBoxes()),
          ),
          noItemsFoundIndicatorBuilder: (context) =>
              buildEmptyIndicator(context),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, BlindBoxModel blindBox) {
    return GestureDetector(
      onTap: () => context.push('/blind-box-detail/${blindBox.blindBoxId}'),
      child: Container(
        decoration: BoxDecoration(
          color: getColorSkin().backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: getColorSkin().primaryRed200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(blindBox),
            _buildDetailsSection(blindBox),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BlindBoxModel blindBox) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: _buildBlindBoxImage(blindBox),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Icon(
            Icons.favorite_border,
            color: getColorSkin().black,
          ),
        ),
      ],
    );
  }

  Widget _buildBlindBoxImage(BlindBoxModel blindBox) {
    final hasValidImages = blindBox.images?.isNotEmpty ?? false;
    final imageUrl = hasValidImages ? blindBox.images!.first.imageUrl : null;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackImage(),
      );
    }

    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      "assets/jpg/blind_box.jpg",
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildDetailsSection(BlindBoxModel blindBox) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductName(blindBox),
          const SizedBox(height: 4),
          _buildPriceInfo(blindBox),
        ],
      ),
    );
  }

  Widget _buildProductName(BlindBoxModel blindBox) {
    return Text(
      blindBox.name ?? "",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: getColorSkin().primaryRed950,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceInfo(BlindBoxModel blindBox) {
    final hasSku = !(blindBox.skus?.isEmpty ?? true);

    if (!hasSku) {
      return const Text('No SKUs available');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${blindBox.skus!.first.price?.toStringAsFixed(2) ?? '0.00'}VND",
          style: TextStyle(
            color: getColorSkin().primaryRed800,
            fontWeight: FontWeight.bold,
          ),
        ),
        if ((blindBox.skus?.length ?? 0) > 1)
          Text(
            "${blindBox.skus![1].price?.toStringAsFixed(2) ?? '0.00'}VND - Set",
            style: TextStyle(
              color: getColorSkin().primaryRed500,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}
