

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/promotion_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

import '../promotion_repository.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  PromotionRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<PromotionModel> getPromotionById(int id) async {
   try{
      PromotionalCampaignDto? promotionalCampaignDto = await _apiService.getPromotionalCampaignById(id);
      if(promotionalCampaignDto == null){
        throw Exception('[PromotionRepositoryImpl]: Cannot get promotion information');
      }
      PromotionModel promotionModel = PromotionMapper.toModel(promotionalCampaignDto);
      return promotionModel;
    }catch(e){
      throw Exception('[PromotionRepositoryImpl]: Cannot get promotion information');
    }
  }

  @override
  Future<PaginationResponseGeneric<PromotionModel>> getPromotions(Pageable pageable, String filter, String search) async {
    try{
      GetPromotionalCampaigns200Response? response = await _apiService.getPromotionalCampaigns(pageable: pageable, filter: filter, search: search);
      if(response == null){
        throw Exception('[PromotionRepositoryImpl]: Cannot get promotion information');
      }
      PaginationResponseGeneric<PromotionModel>? promotionModels = PaginationResponseMapper.toModel(dto: response, fromDTO: (data) => PromotionMapper.toModel(data));
      return promotionModels;
    }
    catch(e){
      throw Exception('[PromotionRepositoryImpl]: Cannot get promotion information');
    }
  }
  

}