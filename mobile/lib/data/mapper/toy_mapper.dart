import 'package:mobile/data/mapper/image_mapper.dart';
import 'package:mobile/data/models/toy_model.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:openapi/api.dart';

class ToyMapper {
  static ToyModel toModel(ToyDto dto) {
    // Handle null DTO
    if (dto.toyId == null) {
      return ToyModel(
        toyId: 0,
        name: 'Unknown Toy',
        description: '',
        weight: 0,
        rarity: ToyRarityEnum.REGULAR,
        isVisible: false,
        createdAt: DateTime.now(),
        images: [],
      );
    }

    return ToyModel(
      toyId: dto.toyId!,
      name: dto.name ?? 'Unknown',
      description: dto.description ?? '',
      weight: dto.weight ?? 0,
      rarity: dto.rarity != null
          ? _mapDtoRarity(dto.rarity!)
          : ToyRarityEnum.REGULAR,
      isVisible: dto.isVisible ?? false,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
      images: dto.images?.map((e) => ImageMapper.toModel(e)).toList() ?? [],
    );
  }

  static ToyDto toDto(ToyModel model) {
    return ToyDto(
      toyId: model.toyId ?? 1,
      name: model.name ?? '',
      description: model.description ?? '',
      weight: model.weight ?? 1,
      rarity: _mapModelRarity(model.rarity!),
      isVisible: model.isVisible ?? true,
      createdAt: model.createdAt ?? DateTime.now(),
      updatedAt: model.updatedAt ?? DateTime.now(),
      images: model.images?.map((e) => ImageMapper.toDto(e)).toList() ?? [],
    );
  }

  static ToyRarityEnum _mapDtoRarity(ToyDtoRarityEnum dtoRarity) {
    switch (dtoRarity) {
      case ToyDtoRarityEnum.REGULAR:
        return ToyRarityEnum.REGULAR;
      case ToyDtoRarityEnum.SECRET:
        return ToyRarityEnum.SECRET;
      default:
        throw Exception('Unknown toy rarity: $dtoRarity');
    }
  }

  static ToyDtoRarityEnum _mapModelRarity(ToyRarityEnum dtoRarity) {
    switch (dtoRarity) {
      case ToyRarityEnum.REGULAR:
        return ToyDtoRarityEnum.REGULAR;
      case ToyRarityEnum.SECRET:
        return ToyDtoRarityEnum.SECRET;
    }
  }
}
