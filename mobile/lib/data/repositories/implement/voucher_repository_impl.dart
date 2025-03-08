import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/mapper/voucher_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

import '../../mapper/generic_mapper.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  VoucherRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<VoucherModel> getVoucherById(int id) async {
   try{
      VoucherDto? voucherDto = await _apiService.getVoucherById(id);
      if(voucherDto == null){
        throw Exception('Cannot get voucher information');
      }
      VoucherModel voucherModel = VoucherMapper.toModel(voucherDto);
      return voucherModel;
    }catch(e){
      throw Exception('Cannot get voucher information');
    }
  }

  @override
  Future<PaginationResponseGeneric<VoucherModel>> getVouchers(Pageable pageable, String filter, String search) async {
    try{
      GetVouchers200Response? response = await _apiService.getVouchers(pageable: pageable, filter: filter, search: search);
      if(response == null){
        throw Exception('Cannot get voucher information');
      }
      PaginationResponseGeneric<VoucherModel>? voucherModels = PaginationResponseMapper.toModel(dto: response, fromDTO: (data) => VoucherMapper.toModel(data));
      return voucherModels;
    }
    catch(e){
      throw Exception('Cannot get voucher information');
    }
  }

}
