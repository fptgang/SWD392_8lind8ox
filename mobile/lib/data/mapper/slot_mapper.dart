import 'package:mobile/data/mapper/toy_mapper.dart';
import 'package:mobile/data/mapper/video_mapper.dart';
import 'package:mobile/data/models/slot_model.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

class SlotMapper {
  static SlotModel toModel(SlotDto dto) {
    return SlotModel(
        slotId: dto.slotId!,
        position: dto.position!,
        state: toSlotStateEnumModel(dto.state ?? SlotDtoStateEnum.AVAILABLE),
        isVisible: dto.isVisible,
        openedAt: dto.openedAt,
        toy: ToyMapper.toModel(dto.toy ?? ToyDto()),
        setId: dto.setId,
        createdAt: dto.createdAt!,
        updatedAt: dto.updatedAt,
        video: VideoMapper.toModel(dto.video!));
  }

  static SlotStateEnum toSlotStateEnumModel(SlotDtoStateEnum dto) {
    switch (dto) {
      case SlotDtoStateEnum.AVAILABLE:
        return SlotStateEnum.AVAILABLE;
      case SlotDtoStateEnum.OPENED:
        return SlotStateEnum.OPENED;
      case SlotDtoStateEnum.RESERVED:
        return SlotStateEnum.RESERVED;
      default:
        throw Exception('Unknown order status: $dto');
    }
  }
}
