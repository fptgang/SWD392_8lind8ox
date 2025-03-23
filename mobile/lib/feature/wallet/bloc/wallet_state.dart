import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:openapi/api.dart';

abstract class WalletState {}

class WalletPaginationState implements WalletState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const WalletPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  WalletPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return WalletPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class WalletLoadingState implements WalletState {
  final bool isLoading;
  final String? error;

  const WalletLoadingState({
    this.isLoading = false,
    this.error,
  });

  WalletLoadingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return WalletLoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WalletDataState implements WalletState {
  final AccountModel? account;
  final PaginationResponseGeneric<TransactionModel>? transactions;
  final String? filter;

  const WalletDataState({
    this.account,
    this.transactions,
    this.filter,
  });

  WalletDataState copyWith({
    AccountModel? account,
    PaginationResponseGeneric<TransactionModel>? transactions,
    String? filter
  }) {
    return WalletDataState(
      account: account ?? this.account,
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
    );
  }
}