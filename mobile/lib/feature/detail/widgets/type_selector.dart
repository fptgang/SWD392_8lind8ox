import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/detail/blocs/blindbox_detail_event.dart';

import '../../../data/models/sku_model.dart';
import '../blocs/blindbox_detail_bloc.dart';
import '../blocs/blindbox_detail_state.dart';

class TypeSelector extends StatelessWidget {
  final BlindBoxDataState state;

  const TypeSelector({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blindBox = state.blindBox;
    final skus = blindBox.skus ?? [];

    // If there are no SKUs or only one SKU, don't show the selector
    if (skus.isEmpty || skus.length == 1) {
      return const SizedBox.shrink();
    }

    // Group SKUs by specCount
    final Map<int, List<StockKeepingUnitModel>> skuGroups = {};
    for (var sku in skus) {
      final specCount = sku.specCount ?? 1;
      if (!skuGroups.containsKey(specCount)) {
        skuGroups[specCount] = [];
      }
      skuGroups[specCount]!.add(sku);
    }

    if (skuGroups.length <= 1) {
      return const SizedBox.shrink();
    }

    final List<Map<String, dynamic>> typeOptions = [];
    skuGroups.forEach((specCount, skuList) {
      int totalStock = skuList.fold(0, (sum, sku) => sum + (sku.stock ?? 0));

      String label = specCount <= 1 ? "Single" : "Set ($specCount)";

      typeOptions.add({
        'label': label,
        'specCount': specCount,
        'stock': totalStock,
        'skus': skuList,
      });
    });

    // Find the selected type based on the currently selected SKU
    final selectedSkuSpecCount = state.sku?.specCount ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: getColorSkin().primaryRed950,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: typeOptions.map((type) {
              final isSelected = type['specCount'] == selectedSkuSpecCount;
              final List<StockKeepingUnitModel> skusOfType = type['skus'];

              // Find the first SKU with an image in this type group
              StockKeepingUnitModel? skuWithImage;
              for (var sku in skusOfType) {
                if (sku.image != null &&
                    sku.image!.imageUrl != null &&
                    sku.image!.imageUrl!.isNotEmpty) {
                  skuWithImage = sku;
                  break;
                }
              }

              // If no SKU with image found, use the first SKU in the group
              final StockKeepingUnitModel skuToSelect =
                  skuWithImage ?? skusOfType.first;

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (skusOfType.isNotEmpty) {
                          context.read<BlindBoxDetailBloc>().add(
                                SelectSku(skuId: skuToSelect.skuId!),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? getColorSkin().primaryRed600
                            : getColorSkin().primaryRed50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            type['label'],
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.white
                                  : getColorSkin().primaryRed950,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Stock: ${type['stock']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : (type['stock'] > 0
                                      ? getColorSkin().primaryRed800
                                      : Colors.red),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
