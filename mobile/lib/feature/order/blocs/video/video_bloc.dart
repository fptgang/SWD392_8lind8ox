import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/repositories/video_repository.dart';
import 'package:http/http.dart';
import 'package:mobile/feature/order/blocs/video/video_event.dart';
import 'package:mobile/feature/order/blocs/video/video_state.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:openapi/api.dart';
import 'package:flutter/foundation.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository videoRepository;

  VideoBloc({
    required this.videoRepository,
  }) : super(const VideoState()) {
    on<UploadVideo>(_onUploadVideo);
    on<GetVideoStatus>(_onGetVideoStatus);
    on<DeleteVideo>(_onDeleteVideo);
  }

  Future<void> _onUploadVideo(
    UploadVideo event,
    Emitter<VideoState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Validate file exists
      if (event.file.path.isEmpty) {
        throw Exception('File path is empty');
      }

      // Log file details before upload
      debugPrint('Uploading video file: ${event.file.path}');
      debugPrint('File name: ${event.file.name}');
      debugPrint('File size: ${event.file.length} bytes');

      final videoFile = await MultipartFile.fromPath(
        'videoBlob',
        event.file.path,
      );

      // Validate MultipartFile was created successfully
      if (videoFile == null) {
        throw Exception('Failed to create MultipartFile');
      }

      final result = await videoRepository.uploadVideo(
        event.accountId,
        event.slotId,
        videoFile,
        true,
      );

      // After successful upload, get updated video status
      final videosResponse = await videoRepository.getVideos(
        Pageable(),
        '', // no filter
        '', // no search
      );
      
      // Filter videos by slotId
      final matchingVideos = videosResponse.content.where((video) => 
        video.slotId == event.slotId
      ).toList();

      emit(state.copyWith(
        isLoading: false,
        video: result,
        videoUrl: result.url,
        error: null,
        videos: matchingVideos,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onGetVideoStatus(
    GetVideoStatus event,
    Emitter<VideoState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Get all videos using existing method
      final videosResponse = await videoRepository.getVideos(
        Pageable(),
        '', // no filter
        '', // no search
      );
      
      if (event.slotId.isEmpty) {
        // If slotId is empty, return all videos
        emit(state.copyWith(
          isLoading: false,
          videos: videosResponse.content,
          error: null,
        ));
      } else {
        // Filter videos by slotId
        final matchingVideos = videosResponse.content.where((video) => 
          video.slotId == int.tryParse(event.slotId)
        ).toList();

        if (matchingVideos.isNotEmpty) {
          // Get the latest video
          final latestVideo = matchingVideos.first;
          emit(state.copyWith(
            isLoading: false,
            video: latestVideo,
            videoStatus: latestVideo.isVerified == true ? 'VERIFIED' : 'PENDING',
            videoUrl: latestVideo.url,
            error: null,
            videos: matchingVideos,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            video: null,
            videoStatus: null,
            videoUrl: null,
            videos: [],
            error: null,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteVideo(
    DeleteVideo event,
    Emitter<VideoState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      await videoRepository.deleteVideo(event.videoId);

      // After successful deletion, get updated video status
      final videosResponse = await videoRepository.getVideos(
        Pageable(),
        '', // no filter
        '', // no search
      );
      
      // Filter videos by slotId
      final matchingVideos = videosResponse.content.where((video) => 
        video.slotId == event.slotId
      ).toList();

      emit(state.copyWith(
        isLoading: false,
        video: null,
        videoUrl: null,
        videos: matchingVideos,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
} 