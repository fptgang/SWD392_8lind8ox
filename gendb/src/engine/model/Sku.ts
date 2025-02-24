import { escapeSingleQuotes } from "../utils.js";
import {BlindBox} from "./BlindBox";

export class Sku {
    skuId: number = 0;
    createdAt: Date;
    isVisible: boolean = true;
    name: string = '';
    price: number = 0;
    specCount: number = 1;
    stock: number = 0;
    updatedAt: Date | null = null;
    blindBoxId: number = 0;
    imageId: number | null = null;

    // convenient fields, do not dump
    blindBox?: BlindBox;

    constructor(init?: Partial<Sku>) {
        this.skuId = init?.skuId ?? 0;
        this.createdAt = init?.createdAt ?? new Date();
        this.isVisible = init?.isVisible ?? true;
        this.name = init?.name ?? '';
        this.price = init?.price ?? 0;
        this.specCount = init?.specCount ?? 1;
        this.stock = init?.stock ?? 0;
        this.updatedAt = init?.updatedAt ?? null;
        this.blindBoxId = init?.blindBoxId ?? 0;
        this.imageId = init?.imageId ?? null;
        this.blindBox = init?.blindBox ?? null;
    }

    static dump(records: Sku[]): string {
        if (records.length === 0) return '';

        const fields = [
            'sku_id',
            'created_at',
            'is_visible',
            'name',
            'price',
            'spec_count',
            'stock',
            'updated_at',
            'blind_box_id',
            'image_id'
        ];

        const values = records.map(record => {
            const createdAt = record.createdAt ? `'${record.createdAt.toISOString().slice(0, 19)}.000000'` : 'NULL';
            const updatedAt = record.updatedAt ? `'${record.updatedAt.toISOString().slice(0, 19)}.000000'` : 'NULL';
            
            return `(${[
                record.skuId,
                createdAt,
                record.isVisible ? 1 : 0,
                `'${escapeSingleQuotes(record.name)}'`,
                record.price.toFixed(2),
                record.specCount,
                record.stock,
                updatedAt,
                record.blindBoxId,
                record.imageId === null ? 'NULL' : record.imageId
            ].join(',')})`;
        });

        return `INSERT INTO sku (${fields.join(',')}) VALUES\n${values.join(',\n')};`;
    }
}