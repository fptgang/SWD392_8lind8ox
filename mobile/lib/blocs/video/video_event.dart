abstract class VideoEvent {}

class SelectVideo extends VideoEvent {
  final String video;

  SelectVideo(this.video);
}

class GetVideos extends VideoEvent {}

class GetVideoById extends VideoEvent {
  final int id;

  GetVideoById(this.id);
}