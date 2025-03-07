import {escapeSingleQuotes} from "../utils.js";

export enum PaymentMethod {
    VNPAY = "VNPAY",
    PAYPAL = "PAYPAL",
    INTERNAL_WALLET = "INTERNAL_WALLET"
}

export enum TransactionType {
    DEPOSIT = "DEPOSIT",
    ORDER = "ORDER"
}

export enum TransactionStatus {
    PENDING = "PENDING",
    SUCCESS = "SUCCESS",
    FAILED = "FAILED"
}

export class Transaction {
    transaction_id: number;
    amount: number;
    created_at: Date;
    updated_at: Date;
    new_balance: number;
    old_balance: number;
    payment_method: PaymentMethod | null;
    status: TransactionStatus;
    type: TransactionType;
    account_id: number | null;
    order_id: number | null;

    constructor(init: Partial<Transaction>) {
        this.transaction_id = init.transaction_id ?? 0;
        this.amount = init.amount ?? 0;
        this.created_at = init.created_at ?? new Date();
        this.updated_at = init.updated_at ?? this.created_at;
        this.new_balance = init.new_balance ?? 0;
        this.old_balance = init.old_balance ?? 0;
        this.payment_method = init.payment_method ?? null;
        this.status = init.status ?? TransactionStatus.PENDING;
        this.type = init.type ?? TransactionType.DEPOSIT;
        this.account_id = init.account_id ?? null;
        this.order_id = init.order_id ?? null;
    }

    static dump(records: Transaction[]): string {
        if (records.length === 0) return '';

        const columns = [
            'transaction_id',
            'amount',
            'created_at',
            'updated_at',
            'new_balance',
            'old_balance',
            'payment_method',
            'status',
            'type',
            'account_id',
            'order_id'
        ];

        const values = records.map(record => {
            const row = [
                record.transaction_id,
                record.amount.toFixed(2),
                record.created_at ? `'${record.created_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'` : 'NULL',
                record.updated_at ? `'${record.updated_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'` : 'NULL',
                record.new_balance.toFixed(2),
                record.old_balance.toFixed(2),
                record.payment_method ? `'${escapeSingleQuotes(record.payment_method)}'` : 'NULL',
                record.status ? `'${escapeSingleQuotes(record.status)}'` : 'NULL',
                `'${escapeSingleQuotes(record.type)}'`,
                record.account_id ?? 'NULL',
                record.order_id ?? 'NULL'
            ];
            return `(${row.join(',')})`;
        });

        return `INSERT INTO \`transaction\` (${columns.map(c => '`' + c + '`').join(',')}) VALUES\n${values.join(',\n')};`;
    }
}