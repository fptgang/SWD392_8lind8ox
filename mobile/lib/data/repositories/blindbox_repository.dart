import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';
import '../models/blindbox_model.dart';

@injectable
@Singleton()
abstract class BlindBoxRepository {
  Future<PaginationResponseGeneric<BlindBoxModel>> getBlindBoxes(Pageable pageable, String filter, String search);
  Future<BlindBoxModel> getBlindBoxById(int id);
}