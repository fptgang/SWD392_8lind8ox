import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/image_model.dart';
import 'package:openapi/api.dart';

@injectable
@Singleton()
abstract class ImageRepository {
  Future<ImageModel> getImageById(int id);
  Future<PaginationResponseGeneric<ImageModel>> getImages(Pageable pageable, String filter, String search);
}
