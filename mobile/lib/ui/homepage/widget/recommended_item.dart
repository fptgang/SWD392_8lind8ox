import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cubit/blindbox_list_cubit/blindbox_list_cubit.dart';
import '../../../cubit/blindbox_list_cubit/blindbox_list_state.dart';
import '../../../di/injection.dart';

class RecommendedItems extends StatelessWidget {
  const RecommendedItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blindBoxesCubit = getIt<BlindBoxesCubit>();
    return BlocProvider(
      create: (context) => blindBoxesCubit..getBlindBoxes(),
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

          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: blindBoxes.length,
            itemBuilder: (context, index) {
              final blindBox = blindBoxes[index];
              return GestureDetector(
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
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: blindBox.images.isNotEmpty
                                ? Image.network(
                              blindBox.images[0].imageUrl ?? "",
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint('Image loading error: $error');
                                debugPrint('Image URL attempted: ${blindBox.images[0].imageUrl}');
                                debugPrint('Stack trace: $stackTrace');
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
                              // blindBox.isFavorite == true ? Icons.favorite : Icons.favorite_border,
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
                            ...blindBox.skus.map((sku) =>
                                Text(
                                  "\$${sku.price?.toStringAsFixed(2) ?? '0.00'}",
                                  style: TextStyle(color: getColorSkin().primaryRed800),
                                ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}