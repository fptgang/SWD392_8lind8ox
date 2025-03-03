import 'package:mobile/data/models/image_model.dart';
import 'package:openapi/api.dart';

class ImageMapper {
  static ImageModel toModel(ImageDto dto) {
    return ImageModel(
      imageId: dto.imageId!,
      uploaderId: dto.uploaderId,
      blindBoxId: dto.blindBoxId,
      packId: null,
      imageUrl: dto.imageUrl!,
      isVisible: dto.isVisible!,
      createdAt: dto.createdAt!,
    );
  }

  static ImageDto toDto(ImageModel model) {
    return ImageDto(
      imageId: model.imageId,
      uploaderId: model.uploaderId,
      blindBoxId: model.blindBoxId,
      toyId: null,
      imageUrl: model.imageUrl,
      isVisible: model.isVisible,
      createdAt: model.createdAt,
    );
  }
}
