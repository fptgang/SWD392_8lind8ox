abstract class TransactionEvent {}

class SelectTransaction extends TransactionEvent {
  final String transaction;

  SelectTransaction(this.transaction);
}

class GetTransactions extends TransactionEvent {
  final int pageKey;

  GetTransactions(this.pageKey);
}

class GetTransactionById extends TransactionEvent {
  final int id;

  GetTransactionById(this.id);
}