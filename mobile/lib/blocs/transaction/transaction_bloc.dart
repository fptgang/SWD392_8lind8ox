import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/transaction/transaction_event.dart';
import 'package:mobile/blocs/transaction/transaction_state.dart';
import 'package:mobile/data/repositories/transaction_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;

  TransactionBloc(this._transactionRepository)
      : super(TransactionState(pageable: Pageable(page: 1, size: 20))) {
    on<SelectTransaction>(_onSelectTransaction);
    on<GetTransactions>(_onGetTransactions);
    on<GetTransactionById>(_onGetTransactionById);
  }

  void _onSelectTransaction(
      SelectTransaction event,
      Emitter<TransactionState> emit,
      ) {
    emit(state.copyWith(filter: event.transaction));
  }

  Future<void> _onGetTransactions(
      GetTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final transactions = await _transactionRepository.getTransactions(
          state.pageable,
          state.filter ?? '',
          state.search ?? ''
      );
      debugPrint('transactions: $transactions');

      emit(state.copyWith(
        transactionResponseModel: transactions,
        isLoading: false,
        pageable: Pageable(
          page: state.pageable.page,
          size: 20,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onGetTransactionById(
      GetTransactionById event,
      Emitter<TransactionState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final transaction = await _transactionRepository.getTransactionById(event.id);
      emit(state.copyWith(
          transaction: transaction,
          isLoading: false
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}