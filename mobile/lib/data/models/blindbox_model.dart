import 'package:openapi/api.dart';

class BlindBoxModel {
  int? blindBoxId;
  int? brandId;
  String? name;
  String? description;
  bool? isVisible;
  int? promotionalCampaignId;
  List<ImageDto> images;
  List<ToyDto> toys;
  List<StockKeepingUnitDto> skus;
  List<int> setIds;
  DateTime? createdAt;
  DateTime? updatedAt;

  BlindBoxModel({
    this.blindBoxId,
    this.brandId,
    this.name,
    this.description,
    this.isVisible,
    this.promotionalCampaignId,
    this.images = const [],
    this.toys = const [],
    this.skus = const [],
    this.setIds = const [],
    this.createdAt,
    this.updatedAt,
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