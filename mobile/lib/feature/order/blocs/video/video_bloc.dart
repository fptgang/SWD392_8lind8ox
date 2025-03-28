import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/data/repositories/video_repository.dart';
import 'package:mobile/data/repositories/order_detail_repository.dart';
import 'package:http/http.dart';
import 'package:mobile/feature/order/blocs/video/video_event.dart';
import 'package:mobile/feature/order/blocs/video/video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository videoRepository;
  final OrderDetailRepository orderDetailRepository;

  VideoBloc({
    required this.videoRepository,
    required this.orderDetailRepository,
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

      final videoFile = await MultipartFile.fromPath(
        'video',
        event.file.path,
      );

      final result = await videoRepository.uploadVideo(
        event.accountId,
        event.orderDetailId,
        videoFile,
        true,
      );

      emit(state.copyWith(
        isLoading: false,
        video: result,
        videoUrl: result.url,
        error: null,
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

      final video = await videoRepository.getVideoById(event.orderDetailId);

      emit(state.copyWith(
        isLoading: false,
        video: video,
        videoStatus: video.isVerified == true ? 'VERIFIED' : 'PENDING',
        videoUrl: video.url,
        error: null,
      ));
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

      emit(state.copyWith(
        isLoading: false,
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