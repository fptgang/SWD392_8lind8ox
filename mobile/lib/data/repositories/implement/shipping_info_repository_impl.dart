import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/shipping_info_mapper.dart';
import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/app/main.dart';
import 'package:openapi/api.dart';

class ShippingInfoRepositoryImpl implements ShippingInfoRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  ShippingInfoRepositoryImpl() {
    debugPrint('Shipping info created token: ${box.get('loginToken')}');

    _apiService.apiClient.addDefaultHeader("Authorization", "Bearer ${box.get('loginToken')}");
    debugPrint('authorization header: ' + _apiService.apiClient.authentication.toString());
  }

  @override
  Future<ShippingInfoModel> createShippingInfo(CreateShippingInfoModel shippingInfo) async {
    try {
      debugPrint('Shipping info created token:1 ${box.get('loginToken')}');
      debugPrint('Shipping info dto from repo ipml: ${shippingInfo}');
      ShippingInfoDto? shippingInfoDto = await _apiService.createShippingInfo(ShippingInfoMapper.fromCreateToDto(shippingInfo));
      debugPrint('Shipping info created: $shippingInfoDto');
      if(shippingInfoDto == null){
        throw Exception('Cannot create shipping info information');
      }
      ShippingInfoModel shippingInfoModel = ShippingInfoMapper.toModel(shippingInfoDto);
      return shippingInfoModel;
    } catch(e, stacktrace){
      debugPrint('Error creating shipping info: $e, stackTrace: $stacktrace');
      throw Exception('Cannot create shipping info information: $e');
    }
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
      throw Exception('Cannot get shipping info information, ${e}', );
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