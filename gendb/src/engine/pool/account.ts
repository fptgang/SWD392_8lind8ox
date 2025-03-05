import {SqlFileAppender} from "../appender.js";
import {
  hashPass
} from "../config.js";
import {Account, AccountRole} from "../model/Account.js";

export class accountPool {
  private accounts: Account[] = [];
  private nextId: number = 1;

  add(account: Account) {
    this.accounts.push(account);
  }

  pickAccount(date: Date, role?: AccountRole, requireVerified?: boolean): Account | null {
    const eligibleAccounts = this.accounts.filter(account => {
      const matchesDate = account.created_at <= date;
      const matchesRole = role ? account.role === role : true;
      const isVisible = account.is_visible;
      const isVerifiedIfRequired = requireVerified ? account.is_verified : true;
      const isNotEscrow = account.account_id !== 1;
      return matchesDate && matchesRole && isVisible && isVerifiedIfRequired && isNotEscrow;
    });

    if (eligibleAccounts.length === 0) return null;

    const randomIndex = Math.floor(Math.random() * eligibleAccounts.length);
    return eligibleAccounts[randomIndex];
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + Account.dump(this.accounts);
  }

  count(): number {
    return this.accounts.length;
  }
}

export let AccountPool = new accountPool();
export const DumpAccounts = () => SqlFileAppender.append(AccountPool.dump());

export const ResetAccountPool = (date: Date) => {
  AccountPool = new accountPool();

  AccountPool.add(new Account({
    account_id: AccountPool.getNextId(),
    avatar_url: null,
    balance: 0,
    created_at: date,
    email: 'admin1@blindbox.com',
    first_name: 'Admin',
    is_verified: true,
    is_visible: true,
    last_name: 'One',
    password: hashPass(),
    role: AccountRole.ADMIN,
    updated_at: date,
    verified_at: date
  }));

  AccountPool.add(new Account({
    account_id: AccountPool.getNextId(),
    avatar_url: null,
    balance: 0,
    created_at: date,
    email: 'admin2@blindbox.com',
    first_name: 'Admin',
    is_verified: true,
    is_visible: true,
    last_name: 'Two',
    password: hashPass(),
    role: AccountRole.ADMIN,
    updated_at: date,
    verified_at: date
  }));

  AccountPool.add(new Account({
    account_id: AccountPool.getNextId(),
    avatar_url: null,
    balance: 0,
    created_at: date,
    email: 'staff1@blindbox.com',
    first_name: 'Staff',
    is_verified: true,
    is_visible: true,
    last_name: 'One',
    password: hashPass(),
    role: AccountRole.STAFF,
    updated_at: date,
    verified_at: date
  }));

  AccountPool.add(new Account({
    account_id: AccountPool.getNextId(),
    avatar_url: null,
    balance: 0,
    created_at: date,
    email: 'staff2@blindbox.com',
    first_name: 'Staff',
    is_verified: true,
    is_visible: true,
    last_name: 'Two',
    password: hashPass(),
    role: AccountRole.STAFF,
    updated_at: date,
    verified_at: date
  }));
}
