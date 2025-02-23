
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:openapi/api.dart';

import '../models/blindboxes_response_model.dart';

class BlindBoxMapper {
  static BlindBoxModel toModel(BlindBoxDto dto){
    return BlindBoxModel(
      blindBoxId: dto.blindBoxId ?? 0,
      brandId: dto.brandId ?? 0,
      name: dto.name ?? '',
      description: dto.description ?? '',
      isVisible: dto.isVisible ?? false,
      promotionalCampaignId: dto.promotionalCampaignId,
      images: dto.images,
      toys: dto.toys,
      skus: dto.skus,
      setIds: dto.setIds,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
    );
  }

  static BlindBoxesResponseModel toModels(GetBlindBoxes200Response dto) {
    return BlindBoxesResponseModel(
      content: dto.content.map((e) => BlindBoxMapper.toModel(e)).toList(),
      totalElements: dto.totalElements!,
      totalPages: dto.totalPages!,
      last: dto.last!,
      first: dto.first!,
      numberOfElements: dto.numberOfElements!,
      empty: dto.empty!,
    );
  }

  static BlindBoxDto toDto(BlindBoxModel model) {
    return BlindBoxDto(
      blindBoxId: model.blindBoxId,
      brandId: model.brandId,
      name: model.name,
      description: model.description,
      isVisible: model.isVisible,
      promotionalCampaignId: model.promotionalCampaignId,
      images: model.images ?? [],
      toys: model.toys ?? [],
      skus: model.skus,
      setIds: model.setIds ?? [],
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static GetBlindBoxes200Response toBlindBoxesDto(BlindBoxesResponseModel model) {
    return GetBlindBoxes200Response(
      content: model.content.map((e) => BlindBoxMapper.toDto(e)).toList(),
      totalElements: model.totalElements,
      totalPages: model.totalPages,
      last: model.last,
      first: model.first,
      numberOfElements: model.numberOfElements,
      empty: model.empty,
    );
  }
}