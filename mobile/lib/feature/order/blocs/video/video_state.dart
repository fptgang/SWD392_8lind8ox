import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:openapi/api.dart';

abstract class VideoState {}

class VideoPaginationState implements VideoState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const VideoPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  VideoPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return VideoPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class VideoLoadingState implements VideoState {
  final bool isLoading;
  final String? error;

  const VideoLoadingState({
    this.isLoading = false,
    this.error,
  });

  VideoLoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return VideoLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class VideoDataState implements VideoState {
  final PaginationResponseGeneric<VideoModel>? videoResponseModel;
  final VideoModel? video;
  final String? filter;
  final String? search;

  const VideoDataState({
    this.videoResponseModel,
    this.video,
    this.filter,
    this.search,
  });

  VideoDataState copyWith({
    PaginationResponseGeneric<VideoModel>? videoResponseModel,
    VideoModel? video,
    String? filter,
    String? search,
  }) {
    return VideoDataState(
      videoResponseModel: videoResponseModel ?? this.videoResponseModel,
      video: video ?? this.video,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}