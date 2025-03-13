

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:openapi/api.dart';
import '../models/generic_response_model.dart';

@injectable
@Singleton()
abstract class SkuRepository {
  Future<PaginationResponseGeneric<StockKeepingUnitModel>> getStockKeepingUnits(Pageable pageable, String filter, String search);
  Future<StockKeepingUnitModel> getStockKeepingUnitById(int id);
}