import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_bloc.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_event.dart';
import '../../../blocs/blindbox_detail/blindbox_detail_state.dart';
import '../../../data/models/sku_model.dart';
import '../../../ui/core/theme/theme.dart';

class TypeSelector extends StatelessWidget {
  final BlindBoxDataState state;

  const TypeSelector({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blindBox = state.blindBox;
    final skus = blindBox.skus;
    
    // If there are no SKUs or only one SKU, don't show the selector
    if (skus.isEmpty || skus.length == 1) {
      return const SizedBox.shrink();
    }
    
    // Group SKUs by specCount to differentiate between single items and sets
    final Map<int, List<StockKeepingUnitModel>> skuGroups = {};
    for (var sku in skus) {
      final specCount = sku.specCount ?? 1;
      if (!skuGroups.containsKey(specCount)) {
        skuGroups[specCount] = [];
      }
      skuGroups[specCount]!.add(sku);
    }
    
    // If all SKUs have the same specCount, don't show the selector
    if (skuGroups.length <= 1) {
      return const SizedBox.shrink();
    }
    
    // Create a label for each group
    final List<Map<String, dynamic>> typeOptions = [];
    skuGroups.forEach((specCount, skuList) {
      String label = specCount <= 1 
          ? "Single" 
          : "Set ($specCount)";
          
      typeOptions.add({
        'label': label,
        'specCount': specCount,
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
              
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    // When a type is selected, find the first SKU with this specCount
                    // and dispatch the event to select it
                    final List<StockKeepingUnitModel> skusOfType = type['skus'];
                    if (skusOfType.isNotEmpty) {
                      final firstSkuOfType = skusOfType.first;
                      context.read<BlindBoxDetailBloc>().add(
                            SelectSku(skuId: firstSkuOfType.skuId!),
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
                  child: Text(
                    type['label'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? Colors.white
                          : getColorSkin().primaryRed950,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
} 