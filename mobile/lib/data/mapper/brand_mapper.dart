
import 'package:mobile/data/models/brand_model.dart';
import 'package:openapi/api.dart';

import '../models/brands_response_model.dart';

class BrandMapper{
  static BrandModel toModel(BrandDto dto){
    return BrandModel(
      brandId: dto.brandId ?? 0,
      name: dto.name ?? '',
      description: dto.description ?? '',
      isVisible: dto.isVisible ?? false,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
      blindBoxes: dto.blindBoxes,
    );
  }

  static BrandsResponseModel toModels(GetBrands200Response dto) {
    return BrandsResponseModel(
      content: dto.content.map((e) => BrandMapper.toModel(e)).toList(),
      totalElements: dto.totalElements!,
      totalPages: dto.totalPages!,
      last: dto.last!,
      first: dto.first!,
      numberOfElements: dto.numberOfElements!,
      empty: dto.empty!,
    );
  }
}