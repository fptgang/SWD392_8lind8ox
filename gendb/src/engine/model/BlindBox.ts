import {escapeSingleQuotes} from "../utils.js";
import { Toy } from "./Toy.js";

export class BlindBox {
    blind_box_id: number;
    created_at: Date;
    description: string;
    is_visible: boolean;
    name: string;
    updated_at: Date | null;
    brand_id: number;
    
    // convenient fields, do not dump
    toys?: Toy[];

    constructor(data: Partial<BlindBox>) {
        this.blind_box_id = data.blind_box_id || 0;
        this.created_at = data.created_at || new Date();
        this.description = data.description || '';
        this.is_visible = data.is_visible ?? true; // Default to true as per SQL definition
        this.name = data.name || '';
        this.updated_at = data.updated_at || null;
        this.brand_id = data.brand_id || 0;
        this.toys = data.toys || [];
    }

    static dump(models: BlindBox[]): string {
        if (models.length === 0) return '';

        const fields = [
            'blind_box_id',
            'created_at',
            'description',
            'is_visible',
            'name',
            'updated_at',
            'brand_id'
        ];

        const values = models.map(model => {
            return `(${[
                model.blind_box_id,
                model.created_at ? `'${model.created_at.toISOString().slice(0, 19)}.000000'` : 'NULL',
                `'${escapeSingleQuotes(model.description)}'`,
                model.is_visible ? 1 : 0,
                `'${escapeSingleQuotes(model.name)}'`,
                model.updated_at ? `'${model.updated_at.toISOString().slice(0, 19)}.000000'` : 'NULL',
                model.brand_id
            ].join(',')})`
        }).join(',\n');

        return `INSERT INTO \`blind_box\` (${fields.map(f => `\`${f}\``).join(',')}) VALUES\n${values};`;
    }
}