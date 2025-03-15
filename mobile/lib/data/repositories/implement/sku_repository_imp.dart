import 'package:hive_flutter/adapters.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/sku_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/repositories/sku_repository.dart';
import 'package:openapi/api.dart';

class SkuRepositoryImpl implements SkuRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  SkuRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }
  @override
  Future<StockKeepingUnitModel> getStockKeepingUnitById(int id) async {
    try {
      StockKeepingUnitDto? stockKeepingUnitDto =
          await _apiService.getStockKeepingUnitById(id);
      if (stockKeepingUnitDto == null) {
        throw Exception('Cannot get sku information');
      }
      StockKeepingUnitModel stockKeepingUnitModel =
          SkuMapper.toModel(stockKeepingUnitDto);
      return stockKeepingUnitModel;
    } catch (e) {
      throw Exception('Cannot get sku information');
    }
  }

  @override
  Future<PaginationResponseGeneric<StockKeepingUnitModel>> getStockKeepingUnits(
      Pageable pageable, String filter, String search) async {
    try {
      GetStockKeepingUnits200Response? response =
          await _apiService.getStockKeepingUnits(
              pageable: pageable, filter: filter, search: search);
      if (response == null) {
        throw Exception('Cannot get sku information');
      }
      PaginationResponseGeneric<StockKeepingUnitModel>? stockKeepingUnitModels =
          PaginationResponseMapper.toModel(
              dto: response, fromDTO: (data) => SkuMapper.toModel(data));
      return stockKeepingUnitModels;
    } catch (e) {
      throw Exception('Cannot get sku information');
    }
  }
}
