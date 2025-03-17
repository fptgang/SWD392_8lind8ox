import 'package:http/http.dart';

abstract class VideoEvent {}

class SelectVideo extends VideoEvent {
  final String video;

  SelectVideo(this.video);
}

class GetVideos extends VideoEvent {
  final int pageKey;

  GetVideos(this.pageKey);
}

class GetVideoById extends VideoEvent {
  final int id;

  GetVideoById(this.id);
}

class UploadVideo extends VideoEvent {
  final int? accountId;
  final int? slotId;
  final MultipartFile videoBlob;
  final bool? isVisible;

  UploadVideo({
    this.accountId,
    this.slotId,
    required this.videoBlob,
    this.isVisible = true,
  });
}

class DeleteVideo extends VideoEvent {
  final int id;

  DeleteVideo(this.id);
}