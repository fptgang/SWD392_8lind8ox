import 'package:mobile/data/mapper/blindbox_campaign_mapper.dart';
import 'package:mobile/data/mapper/brand_mapper.dart';
import 'package:mobile/data/mapper/image_mapper.dart';
import 'package:mobile/data/mapper/sku_mapper.dart';
import 'package:mobile/data/mapper/toy_mapper.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:openapi/api.dart';


class BlindBoxMapper {
  static BlindBoxModel toModel(BlindBoxDto dto) {
    return BlindBoxModel(
      blindBoxId: dto.blindBoxId ?? 0,
      brand: BrandMapper.toModel(dto.brand ?? BrandDto()),
      name: dto.name ?? '',
      description: dto.description ?? '',
      images: dto.images.map((e) => ImageMapper.toModel(e)).toList(),
      blindBoxCampaigns: dto.blindBoxCampaigns.map((e) => BlindBoxCampaignMapper.toModel(e)).toList(),
      isVisible: dto.isVisible ?? false,
      toys: dto.toys.map((e) => ToyMapper.toModel(e)).toList(),
      skus: dto.skus.map((e) => SkuMapper.toModel(e)).toList(),
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
    );
  }
  //
  // static BlindBoxDto toDto(BlindBoxModel model) {
  //   return BlindBoxDto(
  //     blindBoxId: model.blindBoxId,
  //     brandId: model.brandId,
  //     name: model.name,
  //     description: model.description,
  //     isVisible: model.isVisible,
  //     toys: model.toys ?? [],
  //     skus: model.skus,
  //     setIds: model.setIds ?? [],
  //     createdAt: model.createdAt,
  //     updatedAt: model.updatedAt,
  //   );
  // }

  // static GetBlindBoxes200Response toBlindBoxesDto(BlindBoxesResponseModel model) {
  //   return GetBlindBoxes200Response(
  //     content: model.content.map((e) => BlindBoxMapper.toDto(e)).toList(),
  //     totalElements: model.totalElements,
  //     totalPages: model.totalPages,
  //     last: model.last,
  //     first: model.first,
  //     numberOfElements: model.numberOfElements,
  //     empty: model.empty,
  //   );
  // }
}
