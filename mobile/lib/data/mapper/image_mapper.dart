import 'package:mobile/data/models/image_model.dart';
import 'package:openapi/api.dart';

class ImageMapper {
  static ImageModel toModel(ImageDto dto) {
    return ImageModel(
      imageId: dto.imageId!,
      uploaderId: dto.uploaderId,
      blindBoxId: dto.blindBoxId,
      packId: dto.packId,
      imageUrl: dto.imageUrl!,
      isVisible: dto.isVisible!,
      createdAt: dto.createdAt!,
    );
  }
}
