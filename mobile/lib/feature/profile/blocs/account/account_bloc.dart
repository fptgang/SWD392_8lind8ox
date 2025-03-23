import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/feature/profile/blocs/account/account_event.dart';
import 'package:mobile/feature/profile/blocs/account/account_state.dart';

@injectable
@lazySingleton
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _accountRepository;

  AccountBloc(this._accountRepository) : super(const AccountInitial()) {
    on<LoadAccount>(_onLoadAccount);
    on<RefreshAccount>(_onRefreshAccount);
  }

  Future<void> _onLoadAccount(
    LoadAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      if (state is AccountLoaded && !event.forceRefresh) {
        return;
      }

      emit(const AccountLoading());
      
      final account = await _accountRepository.getUser();
      
      debugPrint('Account loaded: ${account.accountId}, name: ${account.firstName} ${account.lastName}');
      debugPrint('Default shipping address: ${account.defaultShippingInfo?.shippingInfoId}');
      
      emit(AccountLoaded(
        account: account,
        defaultShippingAddress: account.defaultShippingInfo,
      ));
    } catch (e) {
      debugPrint('Error loading account: $e');
      emit(AccountError(error: e.toString()));
    }
  }

  Future<void> _onRefreshAccount(
    RefreshAccount event,
    Emitter<AccountState> emit,
  ) async {
    add(const LoadAccount(forceRefresh: true));
  }
  
  ShippingInfoModel? getDefaultShippingAddress() {
    if (state is AccountLoaded) {
      return (state as AccountLoaded).defaultShippingAddress;
    }
    return null;
  }
  
  AccountModel? getAccount() {
    if (state is AccountLoaded) {
      return (state as AccountLoaded).account;
    }
    return null;
  }
} 