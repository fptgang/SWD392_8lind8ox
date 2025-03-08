
import 'package:mobile/data/models/brand_model.dart';
import 'package:openapi/api.dart';

class BrandMapper{
  static BrandModel toModel(BrandDto dto){
    return BrandModel(
      brandId: dto.brandId ?? 0,
      name: dto.name ?? '',
      description: dto.description ?? '',
      isVisible: dto.isVisible ?? false,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
    );
  }


  // static BrandDto toDto(BrandModel model) {
  //   return BrandDto(
  //     brandId: model.brandId,
  //     name: model.name,
  //     description: model.description,
  //     isVisible: model.isVisible,
  //     createdAt: model.createdAt,
  //     updatedAt: model.updatedAt,
  //   );
  // }
  //
  // static GetBrands200Response toDtoBrands(BrandsResponseModel model) {
  //   return GetBrands200Response(
  //     content: model.content.map((e) => BrandMapper.toDto(e)).toList(),
  //     totalElements: model.totalElements,
  //     totalPages: model.totalPages,
  //     last: model.last,
  //     first: model.first,
  //     numberOfElements: model.numberOfElements,
  //     empty: model.empty,
  //   );
  // }
}