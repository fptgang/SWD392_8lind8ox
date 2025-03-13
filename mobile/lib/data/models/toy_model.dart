

import 'package:mobile/data/models/image_model.dart';
import 'package:mobile/enum/enum.dart';

class ToyModel {
  final int? toyId;
  final String? name;
  final String? description;
  final double? weight;
  final ToyRarityEnum? rarity;
  final bool? isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ImageModel>? images;

  ToyModel({
    this.toyId,
    this.name,
    this.description,
    this.weight,
    this.rarity,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
    this.images,
  });

  List<Object?> get props => [
    toyId,
    name,
    description,
    weight,
    rarity,
    isVisible,
    createdAt,
    updatedAt,
    images,
  ];
}