

import 'package:mobile/data/models/sku_model.dart';
import 'package:openapi/api.dart';

class SkuMapper{
  static StockKeepingUnitModel toModel(StockKeepingUnitDto dto){
    return StockKeepingUnitModel(
      skuId: dto.skuId!,
      name: dto.name!,
      imageId: dto.imageId!,
      price: dto.price!,
      stock: dto.stock!,
      specCount: dto.specCount!,
      blindBoxId: dto.blindBoxId!,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
    );
  }


}