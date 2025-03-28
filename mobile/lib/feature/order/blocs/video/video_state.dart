import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/video_model.dart';

class VideoState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? videoUrl;
  final String? videoStatus;
  final VideoModel? video;
  final PaginationResponseGeneric<VideoModel>? videoResponseModel;

  const VideoState({
    this.isLoading = false,
    this.error,
    this.videoUrl,
    this.videoStatus,
    this.video,
    this.videoResponseModel,
  });

  VideoState copyWith({
    bool? isLoading,
    String? error,
    String? videoUrl,
    String? videoStatus,
    VideoModel? video,
    PaginationResponseGeneric<VideoModel>? videoResponseModel,
  }) {
    return VideoState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      videoUrl: videoUrl ?? this.videoUrl,
      videoStatus: videoStatus ?? this.videoStatus,
      video: video ?? this.video,
      videoResponseModel: videoResponseModel ?? this.videoResponseModel,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    videoUrl,
    videoStatus,
    video,
    videoResponseModel,
  ];
}