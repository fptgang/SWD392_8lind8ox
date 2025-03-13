

import 'package:mobile/data/models/blindbox_model.dart';

class PromotionModel {
  final int? campaignId;
  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? discountRate; //big decimal
  final bool? isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PromotionModel({
    this.campaignId,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.discountRate,
    this.isVisible,
    this.createdAt,
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
    createdAt,
    updatedAt,
  ];
}