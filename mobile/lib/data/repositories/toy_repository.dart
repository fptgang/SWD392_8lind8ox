import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/toy_model.dart';
import 'package:openapi/api.dart';
import '../models/generic_response_model.dart';

@injectable
@Singleton()
abstract class ToyRepository {
  Future<PaginationResponseGeneric<ToyModel>> getToys(Pageable pageable, String filter, String search);
  Future<ToyModel> getToyById(int id);
}