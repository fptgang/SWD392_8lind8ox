import {Sku} from "./Sku";

export class Set {
    set_id: number;
    created_at: Date | null;
    is_visible: boolean;
    updated_at: Date | null;
    blind_box_id: number;
    sku_id: number;

    // convenient fields, do not dump
    sku?: Sku;

    constructor(init?: Partial<Set>) {
        this.set_id = init?.set_id ?? 0;
        this.created_at = init?.created_at ?? null;
        this.is_visible = init?.is_visible ?? true;
        this.updated_at = init?.updated_at ?? null;
        this.blind_box_id = init?.blind_box_id ?? 0;
        this.sku_id = init?.sku_id ?? 0;
        this.sku = init?.sku ?? null;
    }

    static dump(sets: Set[]): string {
        if (sets.length === 0) return '';

        const columns = ['set_id', 'created_at', 'is_visible', 'updated_at', 'blind_box_id', 'sku_id'];
        const header = `INSERT INTO \`sets\` (${columns.map(c => '`' + c + '`').join(',')}) VALUES\n`;

        const values = sets.map(set => {
            const created = set.created_at ? `'${set.created_at.toISOString().slice(0, 19)}.000000'` : 'NULL';
            const updated = set.updated_at ? `'${set.updated_at.toISOString().slice(0, 19)}.000000'` : 'NULL';
            
            return `(${set.set_id},${created},${set.is_visible ? 1 : 0},${updated},${set.blind_box_id},${set.sku_id})`;
        }).join(',\n');

        return header + values + ';';
    }
}