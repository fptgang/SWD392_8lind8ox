
abstract class WalletEvent {}

class LoadWallet extends WalletEvent {}

class LoadTransactions extends WalletEvent {
  final int pageKey;

  LoadTransactions(this.pageKey);
}

class LoadMoreTransactions extends WalletEvent {}

class RefreshWallet extends WalletEvent {}

class InitiateDeposit extends WalletEvent {
  final double amount;

  InitiateDeposit(this.amount);
}

class FilterTransactions extends WalletEvent {
  final String filter;

  FilterTransactions(this.filter);
}