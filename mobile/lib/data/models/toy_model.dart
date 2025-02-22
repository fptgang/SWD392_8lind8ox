

import 'package:mobile/enum/enum.dart';

class ToyModel {
  final int toyId;
  final String name;
  final String description;
  final double weight;
  final ToyRarityEnum rarity;
  final bool isVisible;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int blindBoxId;

  ToyModel({
    required this.toyId,
    required this.name,
    required this.description,
    required this.weight,
    required this.rarity,
    required this.isVisible,
    required this.createdAt,
    this.updatedAt,
    required this.blindBoxId,
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
    blindBoxId,
  ];
}