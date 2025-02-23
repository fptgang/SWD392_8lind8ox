import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/ui/common/error.dart';
import 'package:mobile/ui/common/header.dart';
import 'package:mobile/ui/common/no_data.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import '../../../blocs/blindbox_list/blindboxes_event.dart';
import '../../../data/models/blindbox_model.dart';

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({super.key});

  @override
  Widget build(BuildContext context) {
    final blindBoxBloc = context.read<BlindBoxesBloc>();
    return BlocBuilder<BlindBoxesBloc, BlindBoxesState>(
      bloc: blindBoxBloc,
      builder: (context, state) {
        if (state is LoadingState) {
          if (state.isLoading && state is! DataState) {
            blindBoxBloc.add(GetBlindBoxes(1));
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state is! DataState) {
            return CommonErrorWidget(
              error: state.error!,
              onRetry: () => context.read<BlindBoxesBloc>().add(RefreshBlindBoxes()),
            );
          }
        }
        return Column(
          children: [
            SectionHeader(
                title: AppLocalizations.of(context)?.recommended ?? "Recommended",
                onSeeAllPressed: () {
                  context.push('/blind-boxes');
                }),
            _buildGridView(context),
          ],
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: PagedGridView<int, BlindBoxModel>(
        shrinkWrap: true,
        pagingController: context.read<BlindBoxesBloc>().pagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        builderDelegate: PagedChildBuilderDelegate<BlindBoxModel>(
          itemBuilder: (context, blindBox, index) => _buildGridItem(context, blindBox),
          firstPageErrorIndicatorBuilder: (context) => CommonErrorWidget(
            // error: AppLocalizations.of(context)?.error ?? 'Error',
            error: 'Error',
            onRetry: () => context.read<BlindBoxesBloc>().add(RefreshBlindBoxes()),
          ),
          noItemsFoundIndicatorBuilder: (context) => buildEmptyIndicator(context),
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
    if (blindBox.images?.isNotEmpty ?? false) {
      return Image.network(
        blindBox.images![0].imageUrl ?? "",
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blindBox.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColorSkin().primaryRed950,
            ),
          ),
          const SizedBox(height: 4),
          ...blindBox.skus.map((sku) => Text(
            "\$${sku.price?.toStringAsFixed(2) ?? '0.00'}",
            style: TextStyle(color: getColorSkin().primaryRed800),
          )),
        ],
      ),
    );
  }

}