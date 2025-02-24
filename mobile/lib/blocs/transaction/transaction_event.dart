abstract class TransactionEvent {}

class SelectTransaction extends TransactionEvent {
  final String transaction;

  SelectTransaction(this.transaction);
}

class GetTransactions extends TransactionEvent {}

class GetTransactionById extends TransactionEvent {
  final int id;

  GetTransactionById(this.id);
}