import 'package:flutter/cupertino.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:openapi/api.dart';
import '../../../di/injection.dart';
import '../../mapper/blindbox_mapper.dart';
import '../../models/blindboxes_response_model.dart';
import '../blindbox_repository.dart';

class BlindBoxRepositoryImpl implements BlindBoxRepository {
  final DefaultApi _apiService = getIt<DefaultApi>();

  @override
  Future<BlindBoxModel> getBlindBoxById(int id) async {
    try {
      BlindBoxDto? blindBoxDto = await _apiService.getBlindBoxById(id);
      if (blindBoxDto == null) {
        throw Exception("Cannot get blindbox information");
      }
      BlindBoxModel blindBoxModel = BlindBoxMapper.toModel(blindBoxDto);
      return blindBoxModel;
    } catch (e) {
      debugPrint(
          '[BlindBox Repository Impl]: error from get blindbox by id: $e');
      throw Exception('Cannot get blindbox information');
    }
  }

  @override
  Future<BlindBoxesResponseModel> getBlindBoxes(Pageable pageable, String filter, String search) async {
    try {
      GetBlindBoxes200Response? blindBoxes = await _apiService.getBlindBoxes(pageable: pageable, filter: filter, search: search);
      if (blindBoxes == null) {
        throw Exception("Cannot get blind boxes");
      }
      BlindBoxesResponseModel blindBoxModels = BlindBoxMapper.toModels(blindBoxes);
      return blindBoxModels;
    } catch (e) {
      debugPrint('[BlindBox Repository Impl]: error from get blind boxes: $e');
      throw Exception('Cannot get blind boxes');
    }
  }
}
