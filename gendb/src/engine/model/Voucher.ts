import {escapeSingleQuotes} from "../utils.js";

export enum VoucherState {
    USED = "USED", AVAILABLE = "AVAILABLE", RESERVED = "RESERVED"
}

export class Voucher {
    voucherId: number;
    code: string; 
    createdAt: Date;
    updatedAt: Date | null;
    discountRate: number;
    expiredAt: Date;
    state: VoucherState;
    limitAmount: number;
    accountId: number;
    orderId: number | null;

    constructor(partial: Partial<Voucher>) {
        this.voucherId = partial.voucherId || 0;
        this.code = partial.code || '';
        this.createdAt = partial.createdAt || new Date();
        this.updatedAt = partial.updatedAt || null;
        this.discountRate = partial.discountRate || 0;
        this.expiredAt = partial.expiredAt || new Date();
        this.state = partial.state || VoucherState.AVAILABLE;
        this.limitAmount = partial.limitAmount || 0;
        this.accountId = partial.accountId || 0;
        this.orderId = partial.orderId ?? null;
    }

    static dump(models: Voucher[]): string {
        if (models.length === 0) return '';

        const fields = ['voucher_id', 'code', 'created_at', 'updated_at', 'discount_rate',
                       'expired_at', 'state', 'limit_amount', 'account_id', 'order_id'];

        const values = models.map(model => {
            return '(' + model.voucherId + ',' +
                   "'" + escapeSingleQuotes(model.code) + "'," +
                   "'" + model.createdAt.toISOString().slice(0, 19).replace('T', ' ') + ".000000'," +
                   (model.updatedAt ? "'" + model.updatedAt.toISOString().slice(0, 19).replace('T', ' ') + ".000000'" : 'NULL') + ',' +
                   model.discountRate.toFixed(2) + ',' +
                   "'" + model.expiredAt.toISOString().slice(0, 19).replace('T', ' ') + ".000000'," +
                    `'${escapeSingleQuotes(model.state)}'` + ',' +
                   model.limitAmount.toFixed(2) + ',' +
                   model.accountId + ',' +
                   (model.orderId ?? 'NULL') + ')';
        }).join(',\n');

        return `INSERT INTO voucher (${fields.join(',')}) VALUES\n${values};`;
    }
}