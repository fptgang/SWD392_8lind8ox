
import 'package:mobile/data/mapper/blindbox_mapper.dart';
import 'package:mobile/data/mapper/image_mapper.dart';
import 'package:mobile/data/mapper/sku_mapper.dart';
import 'package:mobile/data/mapper/slot_mapper.dart';
import 'package:mobile/data/models/image_model.dart';
import 'package:mobile/data/models/sets_response_model.dart';
import 'package:openapi/api.dart';

import '../models/set_model.dart';

class SetMapper{
  static SetModel toModel(SetDto dto) {
    return SetModel(
      setId: dto.setId!,
      sku: SkuMapper.toModel(dto.sku!),
      images: dto.images.map((e) => ImageMapper.toModel(e)).toList(),
      isVisible: dto.isVisible,
      slots: dto.slots.map((e) => SlotMapper.toModel(e)).toList(),
      blindBox: BlindBoxMapper.toModel(dto.blindBox!),
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
    );
  }

  static SetResponseModel toModels(GetSets200Response dto) {
    return SetResponseModel(
      content: dto.content.map((e) => SetMapper.toModel(e)).toList(),
      totalElements: dto.totalElements!,
      totalPages: dto.totalPages!,
      last: dto.last!,
      first: dto.first!,
      numberOfElements: dto.numberOfElements!,
      empty: dto.empty!,
    );
  }
}