import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccount extends AccountEvent {
  final bool forceRefresh;
  
  const LoadAccount({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class RefreshAccount extends AccountEvent {
  const RefreshAccount();
} 