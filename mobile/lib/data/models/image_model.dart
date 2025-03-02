

class ImageModel {
  final int imageId;
  final int? uploaderId;
  final int? blindBoxId;
  final int? packId;
  final String? imageUrl;
  final bool? isVisible;
  final DateTime? createdAt;

  ImageModel({
    required this.imageId,
    this.uploaderId,
    this.blindBoxId,
    this.packId,
    this.imageUrl,
    this.isVisible,
    this.createdAt,
  });

  List<Object?> get props => [
    imageId,
    uploaderId,
    blindBoxId,
    packId,
    imageUrl,
    isVisible,
    createdAt,
  ];
}