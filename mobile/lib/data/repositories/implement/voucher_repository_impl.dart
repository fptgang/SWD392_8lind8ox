import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  VoucherRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<VoucherModel> getVoucherById(int id) {
    // TODO: implement getVoucherById
    throw UnimplementedError();
  }

  @override
  Future<PaginationResponseGeneric<GetVouchers200Response>> getVouchers(Pageable pageable, String filter, String search) {
    // TODO: implement getVouchers
    throw UnimplementedError();
  }

}
