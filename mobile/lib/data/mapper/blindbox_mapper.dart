
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:openapi/api.dart';

import '../models/blindboxes_response_model.dart';

class BlindBoxMapper {
  static BlindBoxModel toModel(BlindBoxDto dto){
    return BlindBoxModel(
      blindBoxId: dto.blindBoxId,
      brandId: dto.brandId,
      name: dto.name,
      description: dto.description,
      isVisible: dto.isVisible,
      promotionalCampaignId: dto.promotionalCampaignId,
      images: dto.images,
      toys: dto.toys,
      skus: dto.skus,
      setIds: dto.setIds,
      createdAt: dto.createdAt,
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

}