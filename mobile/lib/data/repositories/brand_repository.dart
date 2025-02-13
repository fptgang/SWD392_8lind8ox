import 'dart:ffi';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/brands_response_model.dart';
import 'package:openapi/api.dart';
import '../models/brand_model.dart';

@injectable
@Singleton()
abstract class BrandRepository {
  Future<BrandsResponseModel> getBrands(Pageable pageable, String filter, String search);
  Future<BrandModel> getBrandById(int id);
}