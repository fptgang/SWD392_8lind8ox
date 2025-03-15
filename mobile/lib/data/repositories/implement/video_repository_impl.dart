import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/src/multipart_file.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/video_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:mobile/data/repositories/video_repository.dart';
import 'package:openapi/api.dart';

class VideoRepositoryImpl implements VideoRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  VideoRepositoryImpl() {
    _apiService.apiClient
        .addDefaultHeader("Authorization", "Bearer ${box.get('loginToken')}");
  }

  @override
  Future<VideoModel> getVideoById(int id) async {
    try {
      VideoDto? videoDto = await _apiService.getVideoById(id);
      if (videoDto == null) {
        throw Exception('Cannot get video information');
      }
      VideoModel videoModel = VideoMapper.toModel(videoDto);
      return videoModel;
    } catch (e) {
      throw Exception('Cannot get video information');
    }
  }

  @override
  Future<PaginationResponseGeneric<VideoModel>> getVideos(
      Pageable pageable, String filter, String search) async {
    try {
      GetVideos200Response? response = await _apiService.getVideos(
          pageable: pageable, filter: filter, search: search);
      if (response == null) {
        throw Exception('Cannot get video information');
      }
      PaginationResponseGeneric<VideoModel>? videoModels =
          PaginationResponseMapper.toModel(
              dto: response, fromDTO: (data) => VideoMapper.toModel(data));
      return videoModels;
    } catch (e) {
      throw Exception('Cannot get video information');
    }
  }

  @override
  Future<VideoModel> uploadVideo(int accountID, int orderDetailId,
      MultipartFile videoBlob, bool isVisible) {
    // TODO: implement uploadVideo
    throw UnimplementedError();
  }
}
