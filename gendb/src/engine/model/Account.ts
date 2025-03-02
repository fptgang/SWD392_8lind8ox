import {escapeSingleQuotes} from "../utils.js";

export enum AccountRole {
    ADMIN = 'ADMIN',
    CUSTOMER = 'CUSTOMER',
    STAFF = 'STAFF'
}

export class Account {
    account_id: number;
    avatar_url: string | null;
    balance: number;
    created_at: Date;
    email: string;
    first_name: string;
    is_verified: boolean;
    is_visible: boolean;
    last_name: string | null;
    password: string | null;
    role: AccountRole;
    update_balance_at: Date | null;
    updated_at: Date;
    verified_at: Date | null;

    constructor(data: Partial<Account>) {
        this.account_id = data.account_id || 0;
        this.avatar_url = data.avatar_url || null;
        this.balance = data.balance || 0;
        this.created_at = data.created_at || new Date();
        this.email = data.email || '';
        this.first_name = data.first_name || '';
        this.is_verified = data.is_verified || false;
        this.is_visible = data.is_visible !== undefined ? data.is_visible : true;
        this.last_name = data.last_name || null;
        this.password = data.password || null;
        this.role = data.role || AccountRole.CUSTOMER;
        this.update_balance_at = data.update_balance_at || null;
        this.updated_at = data.updated_at || new Date();
        this.verified_at = data.verified_at || null;
    }

    static dump(accounts: Account[]): string {
        if (accounts.length === 0) return '';

        const fields = [
            'account_id',
            'avatar_url',
            'balance',
            'created_at',
            'email',
            'first_name',
            'is_verified',
            'is_visible',
            'last_name',
            'password',
            'role',
            'update_balance_at',
            'updated_at',
            'verified_at'
        ];

        const values = accounts.map(account => {
            const row = [
                account.account_id,
                account.avatar_url ? `'${escapeSingleQuotes(account.avatar_url)}'` : 'NULL',
                account.balance.toFixed(2),
                account.created_at ? `'${account.created_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'` : 'NULL',
                `'${escapeSingleQuotes(account.email)}'`,
                `'${escapeSingleQuotes(account.first_name)}'`,
                account.is_verified ? 1 : 0,
                account.is_visible ? 1 : 0,
                account.last_name ? `'${escapeSingleQuotes(account.last_name)}'` : 'NULL',
                account.password ? `'${escapeSingleQuotes(account.password)}'` : 'NULL',
                `'${account.role}'`,
                account.update_balance_at ? `'${account.update_balance_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'` : 'NULL',
                account.updated_at ? `'${account.updated_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'` : 'NULL',
                account.verified_at ? `'${account.verified_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'` : 'NULL'
            ];
            return `(${row.join(',')})`;
        });

        return `INSERT INTO \`account\` (${fields.map(f => '`' + f + '`').join(',')}) VALUES\n${values.join(',\n')};`;
    }
}