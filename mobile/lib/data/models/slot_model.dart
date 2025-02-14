import 'package:openapi/api.dart';

class SlotModel {
  int? slotId;
  int? position;
  bool? isOpened;
  DateTime? openedAt;
  int? toyId;
  int? setId;
  int? orderDetailId;
  DateTime? createdAt;
  DateTime? updatedAt;

  SlotModel({
    this.slotId,
    this.position,
    this.isOpened,
    this.openedAt,
    this.toyId,
    this.setId,
    this.orderDetailId,
    this.createdAt,
    this.updatedAt,
  });

  List<Object> get props => [
    slotId!,
    position!,
    isOpened!,
    openedAt!,
    toyId!,
    setId!,
    orderDetailId!,
    createdAt!,
    updatedAt!,
  ];
}