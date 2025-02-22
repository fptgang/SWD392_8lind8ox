import 'package:mobile/data/models/video_model.dart';
import 'package:openapi/api.dart';

class SlotModel {
  int slotId;
  int? position;
  bool? isOpened;
  DateTime? openedAt;
  int? toyId;
  int? setId;
  int? orderDetailId;
  DateTime? createdAt;
  DateTime? updatedAt;
  VideoModel? video;

  SlotModel({
    required this.slotId,
    this.position,
    this.isOpened,
    this.openedAt,
    this.toyId,
    this.setId,
    this.orderDetailId,
    this.createdAt,
    this.updatedAt,
    this.video,
  });

  List<Object?> get props => [
    slotId,
    position,
    isOpened,
    openedAt,
    toyId,
    setId,
    orderDetailId,
    createdAt,
    updatedAt,
    video,
  ];
}