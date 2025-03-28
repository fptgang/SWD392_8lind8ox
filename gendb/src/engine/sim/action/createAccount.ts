import {faker} from "@faker-js/faker";
import {Account, AccountRole} from "../../model/Account";
import {hashPass} from "../../config";
import {AccountPool} from "../../pool/account";

export const createAccount = (date: Date) => {
  const firstName = faker.person.firstName();
  const lastName = faker.person.lastName();
  const verified = faker.datatype.boolean();
  const accId = AccountPool.getNextId();

  const account = new Account({
    account_id: accId,
    avatar_url: faker.image.avatar(),
    balance: 0,
    created_at: date,
    email: `acc${accId}@blindbox.com`,
    first_name: firstName,
    is_visible: true,
    last_name: lastName,
    password: hashPass(),
    role: AccountRole.CUSTOMER,
    updated_at: date
  });

  AccountPool.add(account);
  return account;
}
