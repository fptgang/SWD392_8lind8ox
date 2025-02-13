import 'package:injectable/injectable.dart';
import 'package:openapi/api.dart';
import '../models/blindbox_model.dart';
import '../models/blindboxes_response_model.dart';

@injectable
@Singleton()
abstract class BlindBoxRepository {
  Future<BlindBoxesResponseModel> getBlindBoxes(Pageable pageable, String filter, String search);
  Future<BlindBoxModel> getBlindBoxById(int id);
}