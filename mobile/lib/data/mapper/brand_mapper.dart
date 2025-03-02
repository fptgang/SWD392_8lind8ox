
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

  static BrandDto toDto(BrandModel model) {
    return BrandDto(
      brandId: model.brandId,
      name: model.name,
      description: model.description,
      isVisible: model.isVisible,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      blindBoxes: model.blindBoxes,
    );
  }

  static GetBrands200Response toDtoBrands(BrandsResponseModel model) {
    return GetBrands200Response(
      content: model.content.map((e) => BrandMapper.toDto(e)).toList(),
      totalElements: model.totalElements,
      totalPages: model.totalPages,
      last: model.last,
      first: model.first,
      numberOfElements: model.numberOfElements,
      empty: model.empty,
    );
  }
}