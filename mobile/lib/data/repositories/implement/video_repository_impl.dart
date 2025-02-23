

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/src/multipart_file.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:mobile/data/repositories/video_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

class VideoRepositoryImpl implements VideoRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  VideoRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<VideoModel> getVideoById(int id) {
    // TODO: implement getVideoById
    throw UnimplementedError();
  }

  @override
  Future<PaginationResponseGeneric<GetVideos200Response>> getVideos(Pageable pageable, String filter, String search) {
    // TODO: implement getVideos
    throw UnimplementedError();
  }

  @override
  Future<VideoModel> uploadVideo(int accountID, int orderDetailId, MultipartFile videoBlob, bool isVisible) {
    // TODO: implement uploadVideo
    throw UnimplementedError();
  }
  
}