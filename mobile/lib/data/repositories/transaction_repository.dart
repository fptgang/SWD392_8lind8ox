

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:openapi/api.dart';

@injectable
@Singleton()
abstract class TransactionRepository {
  Future<TransactionModel> getTransactionById(int id);
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<PaginationResponseGeneric<TransactionModel>> getTransactions(Pageable? pageable, String? filter, String? search);
}