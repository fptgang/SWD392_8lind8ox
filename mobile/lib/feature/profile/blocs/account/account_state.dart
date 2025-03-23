import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountLoaded extends AccountState {
  final AccountModel account;
  final ShippingInfoModel? defaultShippingAddress;

  const AccountLoaded({
    required this.account,
    this.defaultShippingAddress,
  });

  @override
  List<Object?> get props => [account, defaultShippingAddress];
}

class AccountError extends AccountState {
  final String error;

  const AccountError({required this.error});

  @override
  List<Object?> get props => [error];
} 