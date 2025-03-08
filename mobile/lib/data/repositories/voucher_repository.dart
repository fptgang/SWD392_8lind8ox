

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:openapi/api.dart';


@injectable
@Singleton()
abstract class VoucherRepository {
  Future<VoucherModel> getVoucherById(int id);
  Future<PaginationResponseGeneric<VoucherModel>> getVouchers(Pageable pageable, String filter, String search);
}