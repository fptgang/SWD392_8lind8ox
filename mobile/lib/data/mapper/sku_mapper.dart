

import 'package:mobile/data/mapper/image_mapper.dart';
import 'package:mobile/data/models/image_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:openapi/api.dart';

class SkuMapper{
  static StockKeepingUnitModel toModel(StockKeepingUnitDto dto){
    return StockKeepingUnitModel(
      skuId: dto.skuId!,
      name: dto.name!,
      image: ImageMapper.toModel(dto.image ?? ImageDto()),
      price: dto.price!,
      stock: dto.stock!,
      specCount: dto.specCount!,
      blindBoxId: dto.blindBoxId!,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
      isVisible: dto.isVisible,
    );
  }

  static StockKeepingUnitDto toDto(StockKeepingUnitModel model){
    return StockKeepingUnitDto(
      skuId: model.skuId,
      name: model.name,
      image: ImageMapper.toDto(model.image ?? ImageModel()),
      price: model.price,
      stock: model.stock,
      specCount: model.specCount,
      blindBoxId: model.blindBoxId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isVisible: model.isVisible
    );
  }

}