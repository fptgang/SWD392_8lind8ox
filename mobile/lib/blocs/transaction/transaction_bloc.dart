import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/transaction/transaction_event.dart';
import 'package:mobile/blocs/transaction/transaction_state.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/data/repositories/transaction_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;
  final PagingController<int, TransactionModel> pagingController;

  TransactionPaginationState _paginationState;
  TransactionDataState _dataState;

  TransactionBloc(this._transactionRepository)
      : _paginationState = TransactionPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const TransactionDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(TransactionLoadingState()) {
    on<SelectTransaction>(_onSelectTransaction);
    on<GetTransactions>(_onGetTransactions);
    on<GetTransactionById>(_onGetTransactionById);
  }

  void _onSelectTransaction(
      SelectTransaction event,
      Emitter<TransactionState> emit,
      ) {
    _dataState = _dataState.copyWith(filter: event.transaction);
    emit(_dataState);
  }

  Future<void> _onGetTransactions(
      GetTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoadingState(isLoading: true));

    try {
      final pageable = Pageable(
          page: event.pageKey,
          size: 20,
          sort: ['desc']
      );

      final transactions = await _transactionRepository.getTransactions(
          pageable,
          _dataState.filter ?? '',
          _dataState.search ?? ''
      );
      debugPrint('transactions: $transactions');

      final isLastPage = transactions.content.length < pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(transactions.content);
      } else {
        pagingController.appendPage(
            transactions.content,
            event.pageKey + 1
        );
      }

      _paginationState = _paginationState.copyWith(
        pageable: pageable,
        hasReachedEnd: isLastPage,
      );

      _dataState = _dataState.copyWith(transactionResponseModel: transactions);
      emit(_dataState);
    } catch (error) {
      pagingController.error = error;
      emit(TransactionLoadingState(error: error.toString(), isLoading: false));
    }
  }

  Future<void> _onGetTransactionById(
      GetTransactionById event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoadingState(isLoading: true));

    try {
      final transaction = await _transactionRepository.getTransactionById(event.id);
      _dataState = _dataState.copyWith(transaction: transaction);
      emit(_dataState);
    } catch (e) {
      emit(TransactionLoadingState(error: e.toString()));
    }
  }
}