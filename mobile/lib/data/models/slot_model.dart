import 'package:mobile/data/models/toy_model.dart';
import 'package:mobile/data/models/video_model.dart';
import 'package:mobile/enum/enum.dart';

class SlotModel {
  int? slotId;
  int? position;
  SlotStateEnum? state;
  bool? isVisible;
  DateTime? openedAt;
  ToyModel? toy;
  int? setId;
  DateTime? createdAt;
  DateTime? updatedAt;
  VideoModel? video;

  SlotModel({
    this.slotId,
    this.position,
    this.state,
    this.isVisible,
    this.openedAt,
    this.toy,
    this.setId,
    this.createdAt,
    this.updatedAt,
    this.video,
  });

  List<Object?> get props => [
    slotId,
    position,
    state,
    isVisible,
    openedAt,
    toy,
    setId,
    createdAt,
    updatedAt,
    video,
  ];
}