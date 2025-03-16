import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';

import '../../../app/di/injection.dart';
import '../../mapper/blindbox_mapper.dart';
import '../blindbox_repository.dart';

String token = dotenv.env['TOKEN'] ?? '';

class BlindBoxRepositoryImpl implements BlindBoxRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  BlindBoxRepositoryImpl() {
    if(box.get('loginToken').isNotEmpty) {
      _apiService.apiClient.addDefaultHeader("Authorization", box.get('loginToken'));
    }
  }

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
  Future<PaginationResponseGeneric<BlindBoxModel>> getBlindBoxes(
      Pageable pageable, String filter, String search) async {
    try {
      GetBlindBoxes200Response? blindBoxes = await _apiService.getBlindBoxes(
          pageable: pageable, filter: filter, search: search);
      if (blindBoxes == null) {
        throw Exception("Cannot get blind boxes");
      }
      PaginationResponseGeneric<BlindBoxModel> blindBoxModels =
          PaginationResponseMapper.toModel(
        dto: blindBoxes,
        fromDTO: (data) => BlindBoxMapper.toModel(data),
      );
      debugPrint(
          '[BlindBox Repository Impl]: get blind boxes: ${blindBoxModels.content}');
      return blindBoxModels;
    } catch (e, stackTrace) {
      debugPrint(
          '[BlindBox Repository Impl]: error from get blind boxes: $e, $stackTrace');
      throw Exception('Cannot get blind boxes');
    }
  }
}
