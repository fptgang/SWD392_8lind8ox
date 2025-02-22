import 'package:mobile/data/models/brands_response_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:openapi/api.dart';

class TransactionState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final PaginationResponseGeneric<GetTransactions200Response>? transactionResponseModel;
  final TransactionModel? transaction;
  final String? error;

  TransactionState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.transactionResponseModel,
    this.transaction,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  TransactionState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    final PaginationResponseGeneric<GetTransactions200Response>? transactionResponseModel,
    TransactionModel? transaction,
    String? error,
  }) {
    return TransactionState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      transactionResponseModel: transactionResponseModel ?? this.transactionResponseModel,
      transaction: transaction ?? this.transaction,
      error: error ?? this.error,
    );
  }
}
