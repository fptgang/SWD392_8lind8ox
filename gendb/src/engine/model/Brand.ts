import { escapeSingleQuotes } from "../utils.js";

export class Brand {
    brand_id: number;
    created_at: Date | null;
    description: string;
    is_visible: boolean;
    name: string;
    updated_at: Date | null;

    constructor(data: Partial<Brand>) {
        this.brand_id = data.brand_id || 0;
        this.created_at = data.created_at || null;
        this.description = data.description || '';
        this.is_visible = data.is_visible ?? true; // Default to true as per SQL schema
        this.name = data.name || '';
        this.updated_at = data.updated_at || null;
    }

    static dump(brands: Brand[]): string {
        if (brands.length === 0) return '';

        const fields = ['brand_id', 'created_at', 'description', 'is_visible', 'name', 'updated_at'];
        const header = `INSERT INTO \`brand\` (\`${fields.join('`,`')}\`) VALUES\n`;

        const values = brands.map(brand => {
            const formattedValues = [
                brand.brand_id,
                brand.created_at ? `'${brand.created_at.toISOString().slice(0, 19)}.000000'` : 'NULL',
                `'${escapeSingleQuotes(brand.description)}'`,
                brand.is_visible ? 1 : 0,
                `'${escapeSingleQuotes(brand.name)}'`,
                brand.updated_at ? `'${brand.updated_at.toISOString().slice(0, 19)}.000000'` : 'NULL'
            ];
            return `(${formattedValues.join(',')})`;
        }).join(',\n');

        return header + values + ';';
    }
}