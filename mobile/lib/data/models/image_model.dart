

import 'package:mobile/data/models/account_model.dart';

class ImageModel {
  final int? imageId;
  final AccountModel? uploader;
  final int? blindBoxId;
  final int? toyId;
  final String? imageUrl;
  final bool? isVisible;
  final DateTime? createdAt;

  ImageModel({
    this.imageId,
    this.uploader,
    this.blindBoxId,
    this.toyId,
    this.imageUrl,
    this.isVisible,
    this.createdAt,
  });

  List<Object?> get props => [
    imageId,
    uploader,
    blindBoxId,
    toyId,
    imageUrl,
    isVisible,
    createdAt,
  ];
}