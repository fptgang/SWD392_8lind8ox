import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class UploadVideo extends VideoEvent {
  final int accountId;
  final int slotId;
  final XFile file;

  const UploadVideo({
    required this.accountId,
    required this.slotId,
    required this.file,
  });

  @override
  List<Object?> get props => [accountId, slotId, file];
}

class GetVideoStatus extends VideoEvent {
  final String slotId;

  const GetVideoStatus({
    required this.slotId,
  });

  @override
  List<Object?> get props => [slotId];
}

class DeleteVideo extends VideoEvent {
  final int videoId;
  final int slotId;

  const DeleteVideo({
    required this.videoId,
    required this.slotId,
  });

  @override
  List<Object?> get props => [videoId, slotId];
}