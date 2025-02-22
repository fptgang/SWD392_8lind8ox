import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/video/video_event.dart';
import 'package:mobile/blocs/video/video_state.dart';
import 'package:mobile/data/repositories/video_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository _videoRepository;

  VideoBloc(this._videoRepository)
      : super(VideoState(pageable: Pageable(page: 1, size: 20))) {
    on<SelectVideo>(_onSelectVideo);
    on<GetVideos>(_onGetVideos);
    on<GetVideoById>(_onGetVideoById);
  }

  void _onSelectVideo(
      SelectVideo event,
      Emitter<VideoState> emit,
      ) {
    emit(state.copyWith(filter: event.video));
  }

  Future<void> _onGetVideos(
      GetVideos event,
      Emitter<VideoState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final videos = await _videoRepository.getVideos(
          state.pageable,
          state.filter ?? '',
          state.search ?? ''
      );
      debugPrint('videos: $videos');

      emit(state.copyWith(
        videoResponseModel: videos,
        isLoading: false,
        pageable: Pageable(
          page: state.pageable.page,
          size: 20,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onGetVideoById(
      GetVideoById event,
      Emitter<VideoState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final video = await _videoRepository.getVideoById(event.id);
      emit(state.copyWith(
          video: video,
          isLoading: false
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}