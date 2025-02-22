

import 'package:mobile/data/models/blindbox_model.dart';

class PromotionModel {

  final int campaignId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final num discountRate; //big decimal
  final bool isVisible;
  final List<BlindBoxModel>? blindBoxes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PromotionModel({
    required this.campaignId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.discountRate,
    required this.isVisible,
    required this.blindBoxes,
    required this.createdAt,
    this.updatedAt,
  });

  List<Object?> get props => [
    campaignId,
    title,
    description,
    startDate,
    endDate,
    discountRate,
    isVisible,
    blindBoxes,
    createdAt,
    updatedAt,
  ];
}