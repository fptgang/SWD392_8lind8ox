import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class UploadVideo extends VideoEvent {
  final XFile file;
  final int orderDetailId;
  final int accountId;
  final int? slotId;

  const UploadVideo({
    required this.file,
    required this.orderDetailId,
    required this.accountId,
    this.slotId,
  });

  @override
  List<Object?> get props => [file, orderDetailId, accountId, slotId];
}

class GetVideoStatus extends VideoEvent {
  final int orderDetailId;

  const GetVideoStatus({
    required this.orderDetailId,
  });

  @override
  List<Object?> get props => [orderDetailId];
}

class DeleteVideo extends VideoEvent {
  final int videoId;

  const DeleteVideo({
    required this.videoId,
  });

  @override
  List<Object?> get props => [videoId];
}