import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/transaction_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/data/repositories/transaction_repository.dart';
import 'package:openapi/api.dart';

String token = dotenv.env['TOKEN'] ?? '';

class TransactionRepositoryImpl implements TransactionRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  TransactionRepositoryImpl() {
    if(box.get('loginToken') != null) {
      _apiService.apiClient.addDefaultHeader("Authorization", "Bearer ${box.get('loginToken')}");
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) {
    // TODO: implement createTransaction
    throw UnimplementedError();
  }

  @override
  Future<TransactionModel> getTransactionById(int id) async {
    try {
      TransactionDto? transactionDto = await _apiService.getTransactionById(id);
      if (transactionDto == null) {
        throw Exception('Cannot get transaction information');
      }
      TransactionModel transactionModel =
          TransactionMapper.toModel(transactionDto);
      return transactionModel;
    } catch (e) {
      throw Exception('Cannot get transaction information');
    }
  }

  @override
  Future<PaginationResponseGeneric<TransactionModel>> getTransactions(
      Pageable? pageable, String? filter, String? search) async {
    try {
      GetTransactions200Response? response = await _apiService.getTransactions(
          pageable: pageable, filter: filter, search: search);
      if (response == null) {
        throw Exception('Cannot get transaction information');
      }
      PaginationResponseGeneric<TransactionModel>? transactionModels =
          PaginationResponseMapper.toModel(
              dto: response,
              fromDTO: (data) => TransactionMapper.toModel(data));
      return transactionModels;
    } catch (e) {
      throw Exception('Cannot get transaction information');
    }
  }
}
