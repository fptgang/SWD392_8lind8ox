import 'package:mobile/data/models/blindbox_campaign_model.dart';
import 'package:mobile/data/models/brand_model.dart';
import 'package:mobile/data/models/image_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/models/toy_model.dart';
import 'package:openapi/api.dart';

class BlindBoxModel {
  final int blindBoxId;
  final BrandModel? brand;
  final String name;
  final String description;
  final List<ImageModel>? images;
  final List<BlindBoxCampaignModel> blindBoxCampaigns;
  final bool? isVisible;
  final List<ToyModel>? toys;
  final List<StockKeepingUnitModel> skus;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BlindBoxModel({
    required this.blindBoxId,
    required this.brand,
    required this.name,
    required this.description,
    this.images,
    this.blindBoxCampaigns = const [],
    this.isVisible,
    this.toys = const [],
    this.skus = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  List<Object?> get props => [
    blindBoxId,
    brand,
    name,
    description,
    images,
    blindBoxCampaigns,
    isVisible,
    toys,
    skus,
    createdAt,
    updatedAt,
  ];
}