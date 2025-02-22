import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/video_cubit/video_state.dart';
import 'package:mobile/data/repositories/video_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class VideoCubit extends Cubit<VideoState> {
  final VideoRepository _videoRepository;

  VideoCubit(this._videoRepository) : super(VideoState(pageable: Pageable(page: 1, size: 20,)));

  void selectVideo(String video) {
    emit(state.copyWith(filter: video));
  }

  Future<void> getVideos() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final videos = await _videoRepository.getVideos(
          state.pageable, state.filter ?? '', state.search ?? '');
      debugPrint('videos: $videos');

      emit(state.copyWith(
        videoResponseModel: videos, isLoading: false, pageable: Pageable(
        page: state.pageable.page,
        size: 20,
      ),));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> getVideoById(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final video = await _videoRepository.getVideoById(id);
      emit(state.copyWith(video: video, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

}
