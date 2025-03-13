

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/mapper/blindbox_campaign_mapper.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/repositories/blindbox_campaign_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

import '../../models/blindbox_campaign_model.dart';

class BlindBoxCampaignRepositoryImpl implements BlindBoxCampaignRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  BlindBoxCampaignRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<BlindBoxCampaignModel> getBlindBoxCampaignById(int id) async {
    try{
      BlindBoxCampaignDto? blindBoxCampaignalCampaignDto = null;
      // BlindBoxCampaignDto? blindBoxCampaignalCampaignDto = await _apiService.getBlindBoxCampaignById(id);
      if(blindBoxCampaignalCampaignDto == null){
        throw Exception('[BlindBoxCampaignRepositoryImpl]: Cannot get blindBoxCampaign information');
      }
      BlindBoxCampaignModel blindBoxCampaignModel = BlindBoxCampaignMapper.toModel(blindBoxCampaignalCampaignDto);
      return blindBoxCampaignModel;
    }catch(e){
      throw Exception('[BlindBoxCampaignRepositoryImpl]: Cannot get blindBoxCampaign information');
    }
  }

  @override
  Future<PaginationResponseGeneric<BlindBoxCampaignModel>> getBlindBoxCampaigns(Pageable pageable, String filter, String search) async {
    try{
      final response = null;
      // GetBlindBoxCampaignalCampaigns200Response? response = await _apiService.getBlindBoxCampaignalCampaigns(pageable: pageable, filter: filter, search: search);
      if(response == null){
        throw Exception('[BlindBoxCampaignRepositoryImpl]: Cannot get blindBoxCampaign information');
      }
      PaginationResponseGeneric<BlindBoxCampaignModel>? blindBoxCampaignModels = PaginationResponseMapper.toModel(dto: response, fromDTO: (data) => BlindBoxCampaignMapper.toModel(data));
      return blindBoxCampaignModels;
    }
    catch(e){
      throw Exception('[BlindBoxCampaignRepositoryImpl]: Cannot get blindBoxCampaign information');
    }
  }


}