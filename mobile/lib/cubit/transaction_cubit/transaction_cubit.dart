import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/cubit/transaction_cubit/transaction_state.dart';
import 'package:mobile/data/repositories/transaction_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _transactionRepository;

  TransactionCubit(this._transactionRepository) : super(TransactionState(pageable: Pageable(page: 1, size: 20,)));

  void selectTransaction(String transaction) {
    emit(state.copyWith(filter: transaction));
  }

  Future<void> getTransactions() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final transactions = await _transactionRepository.getTransactions(
          state.pageable, state.filter ?? '', state.search ?? '');
      debugPrint('transactions: $transactions');

      emit(state.copyWith(
        transactionResponseModel: transactions, isLoading: false, pageable: Pageable(
        page: state.pageable.page,
        size: 20,
      ),));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> getTransactionById(int id) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final transaction = await _transactionRepository.getTransactionById(id);
      emit(state.copyWith(transaction: transaction, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

}
