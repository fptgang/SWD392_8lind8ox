import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/video/video_event.dart';
import 'package:mobile/blocs/video/video_state.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:mobile/data/repositories/video_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository _videoRepository;
  final PagingController<int, VideoModel> pagingController;

  VideoPaginationState _paginationState;
  VideoDataState _dataState;

  VideoBloc(this._videoRepository)
      : _paginationState = VideoPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const VideoDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(VideoLoadingState()) {
    on<SelectVideo>(_onSelectVideo);
    on<GetVideos>(_onGetVideos);
    on<GetVideoById>(_onGetVideoById);
  }

  void _onSelectVideo(
      SelectVideo event,
      Emitter<VideoState> emit,
      ) {
    _dataState = _dataState.copyWith(filter: event.video);
    emit(_dataState);
  }

  Future<void> _onGetVideos(
      GetVideos event,
      Emitter<VideoState> emit,
      ) async {
    emit(VideoLoadingState(isLoading: true));

    try {
      final videos = await _videoRepository.getVideos(
          _paginationState.pageable,
          _dataState.filter ?? '',
          _dataState.search ?? ''
      );
      debugPrint('videos: $videos');

      _paginationState = _paginationState.copyWith(
        pageable: Pageable(
          page: _paginationState.pageable.page + 1,
          size: 20,
        ),
      );

      _dataState = _dataState.copyWith(videoResponseModel: videos);
      emit(_dataState);
    } catch (e) {
      emit(VideoLoadingState(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onGetVideoById(
      GetVideoById event,
      Emitter<VideoState> emit,
      ) async {
    emit(VideoLoadingState(isLoading: true));

    try {
      final video = await _videoRepository.getVideoById(event.id);
      _dataState = _dataState.copyWith(video: video);
      emit(_dataState);
    } catch (e) {
      emit(VideoLoadingState(error: e.toString()));
    }
  }
}