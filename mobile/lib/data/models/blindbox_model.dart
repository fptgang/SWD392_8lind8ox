import 'package:openapi/api.dart';

class BlindBoxModel {
  final int blindBoxId;
  final int brandId;
  final String name;
  final String description;
  final bool isVisible;
  final int? promotionalCampaignId;
  final List<ImageDto>? images;
  final List<ToyDto>? toys;
  final List<StockKeepingUnitDto> skus;
  final List<int>? setIds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BlindBoxModel({
    required this.blindBoxId,
    required this.brandId,
    required this.name,
    required this.description,
    required this.isVisible,
    this.promotionalCampaignId,
    this.images = const [],
    this.toys = const [],
    this.skus = const [],
    this.setIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  List<Object?> get props => [
    blindBoxId,
    brandId,
    name,
    description,
    isVisible,
    promotionalCampaignId,
    images,
    toys,
    skus,
    setIds,
    createdAt,
    updatedAt,
  ];
}