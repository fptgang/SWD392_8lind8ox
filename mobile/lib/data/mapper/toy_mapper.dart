

import 'package:mobile/data/models/toy_model.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

class ToyMapper{
  static ToyModel toModel(ToyDto dto){
    return ToyModel(
      toyId: dto.toyId!,
      name: dto.name!,
      description: dto.description!,
      weight: dto.weight!,
      rarity: _mapDtoRarity(dto.rarity!),
      isVisible: dto.isVisible!,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
      blindBoxId: dto.blindBoxId!,
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
}