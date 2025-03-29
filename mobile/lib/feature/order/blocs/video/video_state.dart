import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:openapi/api.dart';

class VideoState extends Equatable {
  final bool isLoading;
  final String? error;
  final VideoModel? video;
  final String? videoUrl;
  final String? videoStatus;
  final List<VideoModel> videos;
  final PaginationResponseGeneric<VideoModel>? videoResponseModel;

  const VideoState({
    this.isLoading = false,
    this.error,
    this.video,
    this.videoUrl,
    this.videoStatus,
    this.videos = const [],
    this.videoResponseModel,
  });

  VideoState copyWith({
    bool? isLoading,
    String? error,
    VideoModel? video,
    String? videoUrl,
    String? videoStatus,
    List<VideoModel>? videos,
    PaginationResponseGeneric<VideoModel>? videoResponseModel,
  }) {
    return VideoState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      video: video,
      videoUrl: videoUrl,
      videoStatus: videoStatus,
      videos: videos ?? this.videos,
      videoResponseModel: videoResponseModel ?? this.videoResponseModel,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    video,
    videoUrl,
    videoStatus,
    videos,
    videoResponseModel,
  ];
}