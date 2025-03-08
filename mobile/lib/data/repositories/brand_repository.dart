import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';

import '../models/brand_model.dart';

@injectable
@Singleton()
abstract class BrandRepository {
  Future<PaginationResponseGeneric<BrandModel>> getBrands(Pageable pageable, String filter, String search);
  Future<BrandModel> getBrandById(int id);
}