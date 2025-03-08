

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/shipping_info_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

class ShippingInfoRepositoryImpl implements ShippingInfoRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  ShippingInfoRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<ShippingInfoModel> createShippingInfo(ShippingInfoDto shippingInfo) {
    // TODO: implement createShippingInfo
    throw UnimplementedError();
  }

  @override
  Future<ShippingInfoModel> getShippingInfoById(int id) async {
    try{
      ShippingInfoDto? shippingInfoDto = await _apiService.getShippingInfoById(id);
      if(shippingInfoDto == null){
        throw Exception('Cannot get shipping info information');
      }
      ShippingInfoModel shippingInfoModel =  ShippingInfoMapper.toModel(shippingInfoDto);
      return shippingInfoModel;
    } catch(e){
      throw Exception('Cannot get shipping info information');
    }
  }

  @override
  Future<PaginationResponseGeneric<ShippingInfoModel>> getShippingInfos(Pageable pageable, String filter, String search) async {
   try{
      GetShippingInfos200Response? response = await _apiService.getShippingInfos(pageable: pageable, filter: filter, search: search);
      if(response == null){
        throw Exception('Cannot get shipping info information');
      }
      PaginationResponseGeneric<ShippingInfoModel>? shippingInfoModels = PaginationResponseMapper.toModel(dto: response, fromDTO: (data) => ShippingInfoMapper.toModel(data));
      return shippingInfoModels;
    }catch(e){
      throw Exception('Cannot get shipping info information');
   }
  }

}