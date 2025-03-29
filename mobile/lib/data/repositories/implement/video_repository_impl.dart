import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/src/multipart_file.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/video_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:mobile/data/repositories/video_repository.dart';
import 'package:openapi/api.dart';
import 'package:http/http.dart' as http;

String token = dotenv.env['TOKEN'] ?? '';

class VideoRepositoryImpl implements VideoRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  VideoRepositoryImpl() {
    if(box.get('loginToken') != null) {
      _apiService.apiClient.addDefaultHeader("Authorization", "Bearer ${box.get('loginToken')}");
    }
  }

  @override
  Future<VideoModel?> getVideoById(int id) async {
    try {
      VideoDto? videoDto = await _apiService.getVideoById(id);
      if (videoDto == null) {
        return null;
      }
      VideoModel videoModel = VideoMapper.toModel(videoDto);
      return videoModel;
    } catch (e, stackTrace) {
      debugPrint('Error from [Video Repository Implement]: $e, stackTrace: $stackTrace');
      if (e.toString().contains('existingVideo is null')) {
        return null;
      }
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
  Future<VideoModel> uploadVideo(int accountID, int slotId,
      MultipartFile videoBlob, bool isVisible) async {
    try {
      // Validate videoBlob
      if (videoBlob == null) {
        throw Exception('Video file is null');
      }

      // Log upload attempt
      debugPrint('Attempting to upload video:');
      debugPrint('Account ID: $accountID');
      debugPrint('Slot ID: $slotId');
      debugPrint('File name: ${videoBlob.filename}');
      debugPrint('Content type: ${videoBlob.contentType}');

      final response = await _apiService.createVideo(
        accountId: accountID,
        slotId: slotId,
        videoBlob: videoBlob,
        isVisible: isVisible,
      );

      if (response == null) {
        throw Exception('Failed to upload video: API response is null');
      }
      VideoDto? videoDto = response;
      if (videoDto == null) {
        throw Exception('Failed to upload video: Video DTO is null');
      }
      return VideoMapper.toModel(videoDto);
    } catch (e) {
      debugPrint('Error uploading video: $e');
      throw Exception('Failed to upload video: $e');
    }
  }

  @override
  Future<void> deleteVideo(int id) async {
    try {
      await _apiService.deleteVideo(id);
    } catch (e, stackTrace) {
      debugPrint('Error: $e, stackTrace: $stackTrace');
      throw Exception('Cannot delete video');
    }
  }

  @override
  Future<List<VideoModel>> getVideosByOrderDetailId(int orderDetailId) async {
    try {
      final response = await _apiService.getVideos(
        pageable: Pageable(),
        filter: 'orderDetailId,eq,$orderDetailId',
        search: '',
      );
      
      if (response == null || response.content == null) {
        return [];
      }
      
      return response.content!.map((dto) => VideoMapper.toModel(dto)).toList();
    } catch (e) {
      debugPrint('Error getting videos by order detail ID: $e');
      return [];
    }
  }
}
