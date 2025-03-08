import 'package:mobile/data/mapper/account_mapper.dart';
import 'package:mobile/data/models/image_model.dart';
import 'package:openapi/api.dart';

class ImageMapper {
  static ImageModel toModel(ImageDto dto) {
    return ImageModel(
      imageId: dto.imageId!,
      uploader: AccountMapper.toModel(dto.uploader ?? AccountDto()),
      blindBoxId: dto.blindBoxId,
      toyId: dto.toyId,
      imageUrl: dto.imageUrl!,
      isVisible: dto.isVisible!,
      createdAt: dto.createdAt!,
    );
  }

  static ImageDto toDto(ImageModel model) {
    return ImageDto(
      imageId: model.imageId,
      uploader: model.uploader != null ? AccountMapper.toDto(model.uploader!) : null,
      blindBoxId: model.blindBoxId,
      toyId: model.toyId,
      imageUrl: model.imageUrl,
      isVisible: model.isVisible,
      createdAt: model.createdAt,
    );
  }
}
