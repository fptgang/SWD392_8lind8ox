import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/toy_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/toy_model.dart';
import 'package:mobile/data/repositories/toy_repository.dart';
import 'package:openapi/api.dart';

String token = dotenv.env['TOKEN'] ?? '';

class ToyRepositoryImpl implements ToyRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  ToyRepositoryImpl() {
    if(box.get('loginToken').isNotEmpty) {
      _apiService.apiClient.addDefaultHeader("Authorization", box.get('loginToken'));
    }
  }
  @override
  Future<ToyModel> getToyById(int id) async {
    try {
      ToyDto? toyDto = await _apiService.getToyById(id);
      if (toyDto == null) {
        throw Exception('Cannot get toy information');
      }
      ToyModel toyModel = ToyMapper.toModel(toyDto);
      return toyModel;
    } catch (e) {
      throw Exception('Cannot get toy information');
    }
  }

  @override
  Future<PaginationResponseGeneric<ToyModel>> getToys(
      Pageable pageable, String filter, String search) async {
    try {
      GetToys200Response? response = await _apiService.getToys(
          pageable: pageable, filter: filter, search: search);
      if (response == null) {
        throw Exception('Cannot get sku information');
      }
      PaginationResponseGeneric<ToyModel>? toyModels =
          PaginationResponseMapper.toModel(
              dto: response, fromDTO: (data) => ToyMapper.toModel(data));
      return toyModels;
    } catch (e) {
      throw Exception('Cannot get sku information');
    }
  }
}
