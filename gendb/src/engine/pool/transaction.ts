import {
  PaymentMethod,
  Transaction,
  TransactionStatus,
  TransactionType
} from "../model/Transaction.js";
import {Account} from "../model/Account.js";
import {faker} from "@faker-js/faker";
import {SqlFileAppender} from "../appender.js";
import {NotificationPool} from "./notification";
import {Notification} from "../model/Notification";
import {depositSuccessRate} from "../config";

export class transactionPool {
  private transactions: Transaction[] = [];
  private nextId: number = 1;

  add(transaction: Transaction) {
    this.transactions.push(transaction);
  }

  deposit(date: Date, account: Account, amount: number): boolean {
    const status = faker.datatype.boolean({probability: depositSuccessRate()});
    const newBalance = status ? account.balance + amount : account.balance;

    const transaction = new Transaction({
      transaction_id: this.getNextId(),
      amount: amount,
      created_at: date,
      new_balance: newBalance,
      old_balance: account.balance,
      payment_method: faker.helpers.enumValue(PaymentMethod),
      status: status ? TransactionStatus.SUCCESS : TransactionStatus.FAILED,
      type: TransactionType.DEPOSIT,
      account_id: account.account_id,
      order_id: null,
    })

    this.transactions.push(transaction);

    if (status) {
      account.balance = newBalance;
      account.update_balance_at = date;

      NotificationPool.add(new Notification({
        account_id: account.account_id,
        created_at: date,
        is_read: false,
        message: `You have deposited \$${amount} to your account. Your new balance is \$${account.balance}`,
        notification_id: NotificationPool.getNextId(),
        updated_at: date
      }))
    }

    return status;
  }

  dump(): string {
    return '\n' + Transaction.dump(this.transactions);
  }

  getNextId(): number {
    return this.nextId++;
  }

  count(): number {
    return this.transactions.length;
  }
}

export let TransactionPool = new transactionPool();
export const ResetTransactionPool = () => TransactionPool = new transactionPool();
export const DumpTransactions = () => SqlFileAppender.append(TransactionPool.dump());
