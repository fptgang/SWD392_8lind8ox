import 'package:mobile/data/mapper/blindbox_campaign_mapper.dart';
import 'package:mobile/data/mapper/brand_mapper.dart';
import 'package:mobile/data/mapper/image_mapper.dart';
import 'package:mobile/data/mapper/sku_mapper.dart';
import 'package:mobile/data/mapper/toy_mapper.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/brand_model.dart';
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
  static BlindBoxDto toDto(BlindBoxModel model) {
    return BlindBoxDto(
      blindBoxId: model.blindBoxId,
      brand: BrandMapper.toDto(model.brand ?? BrandModel()),
      name: model.name,
      description: model.description,
      images: model.images!.map((e) => ImageMapper.toDto(e)).toList(),
      blindBoxCampaigns: model.blindBoxCampaigns!.map((e) => BlindBoxCampaignMapper.toDto(e)).toList(),
      isVisible: model.isVisible,
      toys: model.toys?.map((e) => ToyMapper.toDto(e)).toList() ?? [],
      skus: model.skus?.map((e) => SkuMapper.toDto(e)).toList() ?? [],
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
