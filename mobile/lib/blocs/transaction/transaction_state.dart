import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:openapi/api.dart';

abstract class TransactionState {}

class TransactionPaginationState implements TransactionState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const TransactionPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  TransactionPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return TransactionPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class TransactionLoadingState implements TransactionState {
  final bool isLoading;
  final String? error;

  const TransactionLoadingState({
    this.isLoading = false,
    this.error,
  });

  TransactionLoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return TransactionLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TransactionDataState implements TransactionState {
  final PaginationResponseGeneric<TransactionModel>? transactionResponseModel;
  final TransactionModel? transaction;
  final String? filter;
  final String? search;

  const TransactionDataState({
    this.transactionResponseModel,
    this.transaction,
    this.filter,
    this.search,
  });

  TransactionDataState copyWith({
    PaginationResponseGeneric<TransactionModel>? transactionResponseModel,
    TransactionModel? transaction,
    String? filter,
    String? search,
  }) {
    return TransactionDataState(
      transactionResponseModel: transactionResponseModel ?? this.transactionResponseModel,
      transaction: transaction ?? this.transaction,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}