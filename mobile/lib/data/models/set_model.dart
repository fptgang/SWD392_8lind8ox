import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/models/slot_model.dart';
import 'package:openapi/api.dart';

import 'image_model.dart';

class SetModel {
  int setId;
  StockKeepingUnitModel sku;
  List<ImageModel> images;
  bool? isVisible;
  List<SlotModel> slots;
  BlindBoxModel blindBox;
  DateTime createdAt;
  DateTime? updatedAt;

  SetModel({
    required this.setId,
    required this.sku,
    this.images = const [],
    this.isVisible,
    this.slots = const [],
    required this.blindBox,
    required this.createdAt,
    this.updatedAt,
  });

  List<Object> get props => [
    setId,
    sku,
    images,
    isVisible!,
    slots,
    blindBox,
    createdAt,
    updatedAt!,
  ];
}