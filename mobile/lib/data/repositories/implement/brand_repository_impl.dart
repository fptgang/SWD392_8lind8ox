import 'package:flutter/material.dart';
import 'package:mobile/data/mapper/brand_mapper.dart';
import 'package:mobile/data/models/brand_model.dart';
import 'package:mobile/data/models/brands_response_model.dart';
import 'package:mobile/di/injection.dart';
import 'package:openapi/api.dart';

import '../brand_repository.dart';

class BrandRepositoryImpl implements BrandRepository {
  final DefaultApi _apiService = getIt<DefaultApi>();

  @override
  Future<BrandModel> getBrandById(int id) async {
    try {
      BrandDto? brandDto = await _apiService.getBrandById(id);
      if (brandDto == null) throw Exception("Brand not found");
      return BrandMapper.toModel(brandDto);
    } catch (e) {
      debugPrint('[BrandRepositoryImpl] getBrandById: $e');
      throw Exception('Error getting brand detail');
    }
  }

  @override
  Future<BrandsResponseModel> getBrands(Pageable pageable, String filter, String search) async {
    try {
      GetBrands200Response? response = await _apiService.getBrands(pageable: pageable, filter: filter, search: search);
      if (response == null) throw Exception("Brands not found");
      BrandsResponseModel brandsResponseModel = BrandMapper.toModels(response);
      return brandsResponseModel;
    } catch (e) {
      debugPrint('[BrandRepositoryImpl] getBrands: $e');
      throw Exception('Error getting brands');
    }
  }
}
