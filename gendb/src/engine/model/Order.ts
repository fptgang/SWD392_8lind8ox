import { OrderDetail } from "./OrderDetail";

export class Order {
    order_id: number;
    checkout_price: number;
    created_at: Date;
    original_price: number;
    updated_at: Date;
    account_id: number;
    shipping_info_id: number | null;

    // convenient fields, do not dump
    details?: OrderDetail[];

    constructor(init: Partial<Order>) {
        this.order_id = init.order_id || 0;
        this.checkout_price = init.checkout_price || 0;
        this.created_at = init.created_at || new Date();
        this.original_price = init.original_price || 0;
        this.updated_at = init.updated_at || new Date();
        this.account_id = init.account_id || 0;
        this.shipping_info_id = init.shipping_info_id || null;
        this.details = init.details || [];
    }

    static dump(orders: Order[]): string {
        if (orders.length === 0) return '';

        const fields = [
            'order_id',
            'checkout_price',
            'created_at',
            'original_price',
            'updated_at',
            'account_id',
            'shipping_info_id'
        ];

        const values = orders.map(order => {
            return `(${[
                order.order_id,
                order.checkout_price.toFixed(2),
                `'${order.created_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'`,
                order.original_price.toFixed(2),
                `'${order.updated_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'`,
                order.account_id,
                order.shipping_info_id === null ? 'NULL' : order.shipping_info_id
            ].join(',')})`
        }).join(',\n');

        return `INSERT INTO \`order\` (${fields.map(f => `\`${f}\``).join(',')}) VALUES\n${values};`;
    }
}