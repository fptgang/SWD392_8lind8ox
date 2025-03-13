import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/sku_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/repositories/sku_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

class SkuRepositoryImpl implements SkuRepository {
  final Box _authBox;
  final DefaultApi _apiService;

  SkuRepositoryImpl({Box? authBox, DefaultApi? apiService})
      : _authBox = authBox ?? Hive.box('authentication'),
        _apiService = apiService ?? getIt<DefaultApi>() {
    // Set up authentication header for API requests
    final String? token = _authBox.get('loginToken') as String?;
    if (token != null) {
      _apiService.apiClient.authentication?.applyToParams([], {
        "Authorization": "Bearer $token",
      });
    } else {
      debugPrint('Warning: No login token found in Hive for SKU repository');
    }
  }

  @override
  Future<StockKeepingUnitModel> getStockKeepingUnitById(int id) async {
    try {
      final StockKeepingUnitDto? stockKeepingUnitDto =
          await _apiService.getStockKeepingUnitById(id);

      if (stockKeepingUnitDto == null) {
        throw Exception(
            'Failed to fetch SKU information: API returned null response');
      }

      return SkuMapper.toModel(stockKeepingUnitDto);
    } catch (e) {
      debugPrint('Error fetching SKU with ID $id: $e');
      throw Exception('Failed to retrieve SKU information: ${e.toString()}');
    }
  }

  @override
  Future<PaginationResponseGeneric<StockKeepingUnitModel>> getStockKeepingUnits(
      Pageable pageable, String filter, String search) async {
    try {
      final GetStockKeepingUnits200Response? response =
          await _apiService.getStockKeepingUnits(
              pageable: pageable, filter: filter, search: search);

      if (response == null) {
        throw Exception('Failed to fetch SKUs: API returned null response');
      }

      final PaginationResponseGeneric<StockKeepingUnitModel>
          stockKeepingUnitModels = PaginationResponseMapper.toModel(
              dto: response, fromDTO: (data) => SkuMapper.toModel(data));

      return stockKeepingUnitModels;
    } catch (e) {
      debugPrint('Error fetching SKUs: $e');
      throw Exception('Failed to retrieve SKU list: ${e.toString()}');
    }
  }
}
