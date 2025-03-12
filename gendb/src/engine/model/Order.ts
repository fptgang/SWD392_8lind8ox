import { OrderDetail } from "./OrderDetail";
import {Voucher} from "./Voucher";
import {Account} from "./Account";
import {OrderState} from "./OrderStatusHistory";

export class Order {
    order_id: number;
    final_total: number;
    created_at: Date;
    sub_total: number;
    latest_status: OrderState;
    updated_at: Date;
    account_id: number;
    shipping_info_id: number | null;

    // convenient fields, do not dump
    details?: OrderDetail[];
    voucher: Voucher | null = null;
    account: Account | null = null;

    constructor(init: Partial<Order>) {
        this.order_id = init.order_id || 0;
        this.final_total = init.final_total || 0;
        this.created_at = init.created_at || new Date();
        this.sub_total = init.sub_total || 0;
        this.updated_at = init.updated_at || new Date();
        this.latest_status = init.latest_status || OrderState.CREATED;
        this.account_id = init.account_id || 0;
        this.shipping_info_id = init.shipping_info_id || null;
        this.details = init.details || [];
        this.voucher = init.voucher || null;
        this.account = init.account || null;
    }

    static dump(orders: Order[]): string {
        if (orders.length === 0) return '';

        const fields = [
            'order_id',
            'final_total',
            'created_at',
            'sub_total',
            'latest_status',
            'updated_at',
            'account_id',
            'shipping_info_id'
        ];

        const values = orders.map(order => {
            return `(${[
                order.order_id,
                order.final_total.toFixed(2),
                `'${order.created_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'`,
                order.sub_total.toFixed(2),
                `'${order.latest_status}'`,
                `'${order.updated_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'`,
                order.account_id,
                order.shipping_info_id === null ? 'NULL' : order.shipping_info_id
            ].join(',')})`
        }).join(',\n');

        return `INSERT INTO \`order\` (${fields.map(f => `\`${f}\``).join(',')}) VALUES\n${values};`;
    }
}