

import 'package:mobile/data/mapper/video_mapper.dart';
import 'package:mobile/data/models/slot_model.dart';
import 'package:openapi/api.dart';

class SlotMapper{
  static SlotModel toModel(SlotDto dto){
    return SlotModel(
      slotId: dto.slotId!,
      position: dto.position!,
      isOpened: dto.isOpened!,
      openedAt: dto.openedAt,
      toyId: dto.toyId,
      setId: dto.setId,
      orderDetailId: dto.orderDetailId,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
      video: VideoMapper.toModel(dto.video!)
    );
  }

}