import 'package:flutter/material.dart';
import 'package:mobile/data/mapper/set_mapper.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/data/models/sets_response_model.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/di/injection.dart';
import 'package:openapi/api.dart';

class SetRepositoryImpl implements SetRepository {
  final DefaultApi _apiService = getIt<DefaultApi>();

  @override
  Future<SetModel> getSetById(int id) async {
    try {
      SetDto? setDto = await _apiService.getSetById(id);
      if (setDto == null) {
        throw Exception("Set not found");
      }
      SetModel setModel = SetMapper.toModel(setDto);
      return setModel;
    } catch (e) {
      debugPrint('[SetRepositoryImpl] getSetById: $e');
      throw Exception("Failed to get set");
    }
  }

  @override
  Future<SetResponseModel> getSets(
      Pageable pageable, String filter, String search) async {
    try {
      GetSets200Response? response = await _apiService.getSets(
          pageable: pageable, filter: filter, search: search);
      if (response == null) {
        throw Exception("Failed to get sets");
      }
      SetResponseModel setResponseModel = SetMapper.toModels(response);
      return setResponseModel;
    } catch (e) {
      debugPrint('[SetRepositoryImpl] getSets: $e');
      throw Exception("Failed to get sets");
    }
  }
}
