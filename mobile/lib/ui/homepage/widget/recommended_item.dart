import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../cubit/blindbox_list_cubit/blindbox_list_cubit.dart';
import '../../../cubit/blindbox_list_cubit/blindbox_list_state.dart';
import '../../../data/models/blindbox_model.dart';
import '../../../di/injection.dart';

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({super.key});

  @override
  Widget build(BuildContext context) {
    final blindBoxesCubit = getIt<BlindBoxesCubit>();
    return BlocProvider(
      create: (context) => blindBoxesCubit..getBlindBoxes(1),
      child: BlocBuilder<BlindBoxesCubit, BlindBoxesState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.recommended,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                          AppLocalizations.of(context)!.seeAll,
                          style: TextStyle(color: getColorSkin().black)
                      )
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: PagedGridView<int, BlindBoxModel>(
                  shrinkWrap: true,
                  pagingController: context.read<BlindBoxesCubit>().pagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<BlindBoxModel>(
                    itemBuilder: (context, blindBox, index) => GestureDetector(
                      onTap: () {
                        context.push('/blind-box-detail/${blindBox.blindBoxId}');
                      },
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: getColorSkin().backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: getColorSkin().primaryRed200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)
                                  ),
                                  child: blindBox.images?.isNotEmpty ?? false
                                      ? Image.network(
                                    blindBox.images![0].imageUrl ?? "",
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/jpg/blind_box.jpg",
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                      : Image.asset(
                                    "assets/jpg/blind_box.jpg",
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
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
                            ),
                            Padding(
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
                                  SizedBox(height: 4),
                                  if (blindBox.skus != null)
                                    ...blindBox.skus!.map((sku) => Text(
                                      "\$${sku.price?.toStringAsFixed(2) ?? '0.00'}",
                                      style: TextStyle(
                                          color: getColorSkin().primaryRed800
                                      ),
                                    )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    firstPageErrorIndicatorBuilder: (context) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${blindBoxesCubit.state.error}'),
                          ElevatedButton(
                            onPressed: () => blindBoxesCubit.refresh(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      // child: Text(AppLocalizations.of(context)!.noItemsFound),
                      child: Text('No items found'),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}