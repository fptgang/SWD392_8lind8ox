

import 'package:mobile/data/models/account_model.dart';

class VideoModel{
  final int? videoId;
  final AccountModel? account;
  final int? slotId;
  final String? url;
  final String? description;
  final bool? isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isVerified;

  VideoModel({
    this.videoId,
    this.account,
    this.slotId,
    this.url,
    this.description,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
    this.isVerified,
  });

  List<Object?> get props => [
    videoId,
    account,
    slotId,
    url,
    description,
    isVisible,
    createdAt,
    updatedAt,
    isVisible,
    isVerified,
  ];
}