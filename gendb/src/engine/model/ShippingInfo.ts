import { escapeSingleQuotes } from "../utils.js";

export class ShippingInfo {
    shipping_info_id: number;
    address: string;
    city: string;
    created_at: Date;
    district: string;
    is_visible: boolean;
    name: string;
    phone_number: string;
    updated_at: Date | null;
    ward: string;
    account_id: number | null;

    constructor(data: Partial<ShippingInfo> = {}) {
        this.shipping_info_id = data.shipping_info_id || 0;
        this.address = data.address || 'N/A';
        this.city = data.city || '';
        this.created_at = data.created_at || new Date();
        this.district = data.district || '';
        this.is_visible = data.is_visible ?? true;
        this.name = data.name || '';
        this.phone_number = data.phone_number || '';
        this.updated_at = data.updated_at || null;
        this.ward = data.ward || '';
        this.account_id = data.account_id || null;
    }

    static dump(records: ShippingInfo[]): string {
        if (records.length === 0) return '';

        const fields = [
            'shipping_info_id',
            'address',
            'city',
            'created_at',
            'district',
            'is_visible',
            'name',
            'phone_number',
            'updated_at',
            'ward',
            'account_id'
        ];

        const values = records.map(record => {
            const formattedValues = [
                record.shipping_info_id,
                `'${escapeSingleQuotes(record.address)}'`,
                `'${escapeSingleQuotes(record.city)}'`,
                record.created_at ? `'${record.created_at.toISOString().slice(0, 19).replace('T', ' ')}'` : 'NULL',
                `'${escapeSingleQuotes(record.district)}'`,
                record.is_visible ? 1 : 0,
                `'${escapeSingleQuotes(record.name)}'`,
                `'${escapeSingleQuotes(record.phone_number)}'`,
                record.updated_at ? `'${record.updated_at.toISOString().slice(0, 19).replace('T', ' ')}'` : 'NULL',
                `'${escapeSingleQuotes(record.ward)}'`,
                record.account_id ? record.account_id : 'NULL'
            ];
            return `(${formattedValues.join(',')})`;
        });

        return `INSERT INTO shipping_info (${fields.join(',')}) VALUES\n${values.join(',\n')};`;
    }
}