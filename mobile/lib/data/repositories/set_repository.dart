import 'package:injectable/injectable.dart';
import 'package:openapi/api.dart';

import '../models/set_model.dart';
import '../models/sets_response_model.dart';

@injectable
@Singleton()
abstract class SetRepository {
  Future<SetResponseModel> getSets(Pageable pageable, String filter, String search);
  Future<SetModel> getSetById(int id);
}