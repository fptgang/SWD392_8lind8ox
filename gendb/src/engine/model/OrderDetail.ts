import {Slot} from "./Slot";
import {Sku} from "./Sku";

export class OrderDetail {
    order_detail_id: number;
    final_total: number;
    created_at: Date | null;
    sub_total: number;
    unit_price: number;
    updated_at: Date | null;
    order_id: number;
    campaign_id: number | null;
    slot_id: number | null;
    sku_id: number;
    quantity: number;

    // convenient fields, do not dump
    slot: Slot | null = null;
    sku: Sku | null = null;

    constructor(init?: Partial<OrderDetail>) {
        this.order_detail_id = init?.order_detail_id ?? 0;
        this.final_total = init?.final_total ?? 0;
        this.created_at = init?.created_at ?? null;
        this.sub_total = init?.sub_total ?? 0;
        this.unit_price = init?.unit_price ?? 0;
        this.updated_at = init?.updated_at ?? null;
        this.order_id = init?.order_id ?? 0;
        this.campaign_id = init?.campaign_id ?? null;
        this.slot_id = init?.slot_id ?? null;
        this.sku_id = init?.sku_id ?? 0;
        this.quantity = init?.quantity ?? 0;
        this.slot = init?.slot ?? null;
        this.sku = init?.sku ?? null;
    }

    static dump(records: OrderDetail[]): string {
        if (records.length === 0) return '';

        const fields = [
            'order_detail_id',
            'final_total',
            'created_at',
            'sub_total',
            'unit_price',
            'updated_at',
            'order_id',
            'campaign_id',
            'slot_id',
            'sku_id',
            'quantity'
        ];

        const values = records.map(record => {
            return `(${[
                record.order_detail_id,
                record.final_total.toFixed(2),
                record.created_at ? `'${record.created_at.toISOString().slice(0, 19).replace('T', ' ')}'` : 'NULL',
                record.sub_total.toFixed(2),
                record.unit_price.toFixed(2),
                record.updated_at ? `'${record.updated_at.toISOString().slice(0, 19).replace('T', ' ')}'` : 'NULL',
                record.order_id,
                record.campaign_id ?? 'NULL',
                record.slot_id ?? 'NULL',
                record.sku_id,
                record.quantity
            ].join(', ')})`;
        });

        return `INSERT INTO \`order_details\` (${fields.map(f => `\`${f}\``).join(', ')}) VALUES\n${values.join(',\n')};`;
    }
}