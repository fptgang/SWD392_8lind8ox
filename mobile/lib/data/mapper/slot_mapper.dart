import 'package:mobile/data/mapper/toy_mapper.dart';
import 'package:mobile/data/mapper/video_mapper.dart';
import 'package:mobile/data/models/slot_model.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:openapi/api.dart';

class SlotMapper {
  static SlotModel toModel(SlotDto dto) {
    // Handle null DTO case
    if (dto.slotId == null) {
      return SlotModel(
        slotId: 0,
        position: 0,
        state: SlotStateEnum.AVAILABLE,
        isVisible: false,
        createdAt: DateTime.now(),
      );
    }

    return SlotModel(
        slotId: dto.slotId!,
        position: dto.position ?? 0,
        state: toSlotStateEnumModel(dto.state ?? SlotDtoStateEnum.AVAILABLE),
        isVisible: dto.isVisible,
        openedAt: dto.openedAt,
        toy: dto.toy != null ? ToyMapper.toModel(dto.toy!) : null,
        setId: dto.setId,
        createdAt: dto.createdAt ?? DateTime.now(),
        updatedAt: dto.updatedAt,
        video: dto.video != null ? VideoMapper.toModel(dto.video!) : null);
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
