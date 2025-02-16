import 'package:openapi/api.dart';

class SetModel {
  int? setId;
  double currentPrice;
  List<ImageDto> imageIds;
  bool? isVisible;
  List<SlotDto> slots;
  BlindBoxDto? blindBox;
  DateTime? createdAt;
  DateTime? updatedAt;

  SetModel({
    this.setId,
    required this.currentPrice,
    this.imageIds = const [],
    this.isVisible,
    this.slots = const [],
    this.blindBox,
    this.createdAt,
    this.updatedAt,
  });

  List<Object> get props => [
    setId!,
    currentPrice,
    imageIds,
    isVisible!,
    slots,
    blindBox!,
    createdAt!,
    updatedAt!,
  ];
}