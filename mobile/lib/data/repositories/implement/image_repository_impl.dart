import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/image_model.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

import '../image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  ImageRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<ImageModel> getImageById(int id) {
    // TODO: implement getImageById
    throw UnimplementedError();
  }

  @override
  Future<PaginationResponseGeneric<Page>> getImages(
      Pageable pageable, String filter, String search) {
    // TODO: implement getImages
    throw UnimplementedError();
  }
}
