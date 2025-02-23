import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/mapper/transaction_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/data/repositories/transaction_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  TransactionRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) {
    // TODO: implement createTransaction
    throw UnimplementedError();
  }

  @override
  Future<TransactionModel> getTransactionById(int id) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }

  @override
  Future<PaginationResponseGeneric<GetTransactions200Response>> getTransactions(Pageable pageable, String filter, String search) async {
    // GetTransactions200Response? response = await _apiService.getTransactions(pageable: pageable, filter: filter, search: search);
    // if (response == null) {
    //   throw Exception('Failed to load transactions');
    // }
    //
    // return PaginationResponse.fromDTO<TransactionModel, GetTransactions200Response>(
    //   dto: response,
    //   fromDTO: (data) => TransactionMapper.toModel(data),
    // );
    throw UnimplementedError();
  }

}
