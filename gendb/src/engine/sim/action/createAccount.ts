import {faker} from "@faker-js/faker";
import {Account, AccountRole} from "../../model/Account";
import {hashPass} from "../../config";
import {AccountPool} from "../../pool/account";

export const createAccount = (date: Date) => {
  const firstName = faker.person.firstName();
  const lastName = faker.person.lastName();
  const email = faker.internet.email({firstName, lastName}).toLowerCase();
  const verified = faker.datatype.boolean();

  const account = new Account({
    account_id: AccountPool.getNextId(),
    avatar_url: faker.image.avatar(),
    balance: 0,
    created_at: date,
    email: email,
    first_name: firstName,
    is_verified: verified,
    is_visible: true,
    last_name: lastName,
    password: hashPass(),
    role: AccountRole.CUSTOMER,
    updated_at: date,
    verified_at: verified ? date : null
  });

  AccountPool.add(account);
  return account;
}
