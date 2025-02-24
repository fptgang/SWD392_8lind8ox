import {AccountPool} from "../../pool/account";
import {AccountRole} from "../../model/Account";
import {faker} from "@faker-js/faker";
import {depositAmount} from "../../config";
import {TransactionPool} from "../../pool/transaction";

export function depositCredits(date: Date) {
  const account = AccountPool.pickAccount(new Date(), AccountRole.CUSTOMER, false);

  if (!account) {
    return;
  }

  const amount = faker.number.int(depositAmount());

  TransactionPool.deposit(date, account, amount)
}