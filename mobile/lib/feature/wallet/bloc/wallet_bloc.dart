// lib/feature/wallet/bloc/wallet_bloc.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/data/repositories/transaction_repository.dart';
import 'package:mobile/feature/wallet/bloc/wallet_event.dart';
import 'package:mobile/feature/wallet/bloc/wallet_state.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final PagingController<int, TransactionModel> pagingController;

  WalletPaginationState _paginationState;
  WalletDataState _dataState;

  static const int _pageSize = 10;

  WalletBloc(
      this._transactionRepository,
      this._accountRepository,
      )   : _paginationState = WalletPaginationState(
      pageable: Pageable(page: 0, size: _pageSize, sort: ['createdAt,desc'])),
        _dataState = const WalletDataState(),
        pagingController = PagingController(firstPageKey: 0),
        super(WalletLoadingState()) {
    // Set up pagination controller
    pagingController.addPageRequestListener((pageKey) {
      add(LoadTransactions(pageKey));
    });

    // Register event handlers
    on<LoadWallet>(_onLoadWallet);
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadMoreTransactions>(_onLoadMoreTransactions);
    on<RefreshWallet>(_onRefresh);
    on<InitiateDeposit>(_onInitiateDeposit);
    on<FilterTransactions>(_onFilterTransactions);
  }

  Future<void> _onLoadWallet(
      LoadWallet event,
      Emitter<WalletState> emit,
      ) async {
    emit(WalletLoadingState(isLoading: true));

    try {
      final account = await _accountRepository.getUser();
      _dataState = _dataState.copyWith(account: account);
      emit(_dataState);
    } catch (error) {
      debugPrint('Error loading wallet: $error');
      emit(WalletLoadingState(error: error.toString()));
    }
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event,
      Emitter<WalletState> emit,
      ) async {
    emit(WalletLoadingState(isLoading: true));

    try {
      final pageable = Pageable(
        page: event.pageKey,
        size: _pageSize,
        sort: ['createdAt,desc'],
      );

      final transactionsResponse = await _transactionRepository.getTransactions(
        pageable,
        _dataState.filter ?? '',
        '',
      );

      final isLastPage = transactionsResponse.content.length < _pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(transactionsResponse.content);
      } else {
        pagingController.appendPage(
            transactionsResponse.content, event.pageKey + 1);
      }

      _paginationState = _paginationState.copyWith(
        pageable: pageable,
        hasReachedEnd: isLastPage,
      );

      _dataState = _dataState.copyWith(transactions: transactionsResponse);

      emit(_dataState);
    } catch (error) {
      pagingController.error = error;
      emit(WalletLoadingState(error: error.toString()));
    }
  }

  Future<void> _onLoadMoreTransactions(
      LoadMoreTransactions event,
      Emitter<WalletState> emit,
      ) async {
    if (_paginationState.hasReachedEnd) return;

    try {
      final nextPage = _paginationState.pageable.page + 1;

      add(LoadTransactions(nextPage));
    } catch (e) {
      debugPrint('Error loading more transactions: $e');
    }
  }

  Future<void> _onRefresh(
      RefreshWallet event,
      Emitter<WalletState> emit,
      ) async {
    emit(WalletLoadingState(isLoading: true));

    try {
      // Reset pagination controller
      pagingController.refresh();

      // Reset pagination state
      _paginationState = WalletPaginationState(
        pageable: Pageable(page: 0, size: _pageSize, sort: ['createdAt,desc']),
      );

      // Reload wallet
      add(LoadWallet());

      // Reload transactions
      add(LoadTransactions(0));
    } catch (e) {
      debugPrint('Error refreshing wallet: $e');
      emit(WalletLoadingState(error: e.toString()));
    }
  }

  Future<void> _onInitiateDeposit(
      InitiateDeposit event,
      Emitter<WalletState> emit,
      ) async {
    emit(WalletLoadingState(isLoading: true));

    try {
      // Initiate the deposit
      // final transaction = await _transactionRepository.initiateDeposit(event.amount);

      // Refresh wallet to get updated balance
      final account = await _accountRepository.getUser();

      // Update state
      _dataState = _dataState.copyWith(account: account);

      // Refresh transactions to include the new deposit
      add(RefreshWallet());

      emit(_dataState);
    } catch (error) {
      debugPrint('Error initiating deposit: $error');
      emit(WalletLoadingState(error: error.toString()));
    }
  }

  void _onFilterTransactions(
      FilterTransactions event,
      Emitter<WalletState> emit,
      ) {
    _dataState = _dataState.copyWith(filter: event.filter);
    _paginationState = _paginationState.copyWith(
      pageable: Pageable(page: 0, size: _pageSize, sort: ['createdAt,desc']),
    );
    pagingController.refresh();
  }
}