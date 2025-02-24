import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:openapi/api.dart';

class VideoState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final PaginationResponseGeneric<GetVideos200Response>? videoResponseModel;
  final VideoModel? video;
  final String? error;

  VideoState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.videoResponseModel,
    this.video,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  VideoState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    final PaginationResponseGeneric<GetVideos200Response>? videoResponseModel,
    VideoModel? video,
    String? error,
  }) {
    return VideoState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      videoResponseModel: videoResponseModel ?? this.videoResponseModel,
      video: video ?? this.video,
      error: error ?? this.error,
    );
  }
}
