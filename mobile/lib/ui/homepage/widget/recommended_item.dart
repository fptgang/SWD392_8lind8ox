import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../blocs/blindbox_list/blindboxes_event.dart';
import '../../../data/models/blindbox_model.dart';
import '../../../di/injection.dart';

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BlindBoxesBloc>()..add(GetBlindBoxes(1)),
      child: BlocBuilder<BlindBoxesBloc, BlindBoxesState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildHeader(context),
              _buildGridView(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.recommended,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: () {
              // Implement see all functionality
            },
            child: Text(
              AppLocalizations.of(context)!.seeAll,
              style: TextStyle(color: getColorSkin().black),
            ),
          ),
        ],
      ),
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
          firstPageErrorIndicatorBuilder: (context) => _buildErrorIndicator(context),
          noItemsFoundIndicatorBuilder: (context) => _buildEmptyIndicator(context),
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
            blindBox.name ?? "Unnamed Box",
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

  Widget _buildErrorIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${LoadingState().isLoading}'),
          ElevatedButton(
            onPressed: () => context.read<BlindBoxesBloc>().add(RefreshBlindBoxes()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyIndicator(BuildContext context) {
    return Center(
      // child: Text(AppLocalizations.of(context)?.noItemsFound ?? 'No items found'),
      child: const Text('No items found'),
    );
  }
}