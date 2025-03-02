import {escapeSingleQuotes} from "../utils.js";

export class Image {
    image_id: number;
    created_at: Date;
    image_url: string;
    is_visible: boolean;
    blind_box_id: number;
    uploader_id: number;
    toy_id: number | null;

    constructor(data: Partial<Image>) {
        this.image_id = data.image_id || 0;
        this.created_at = data.created_at || new Date();
        this.image_url = data.image_url || '';
        this.is_visible = data.is_visible ?? true;
        this.blind_box_id = data.blind_box_id || 0;
        this.uploader_id = data.uploader_id || 0;
        this.toy_id = data.toy_id || null;
    }

    static dump(images: Image[]): string {
        if (images.length === 0) return '';

        const fields = [
            'image_id',
            'created_at',
            'image_url',
            'is_visible',
            'blind_box_id',
            'uploader_id',
            'toy_id'
        ];

        const values = images.map(image => {
            return `(${[
                image.image_id,
                `'${image.created_at.toISOString().slice(0, 19).replace('T', ' ')}.000000'`,
                `'${escapeSingleQuotes(image.image_url)}'`,
                image.is_visible ? 1 : 0,
                image.blind_box_id,
                image.uploader_id,
                image.toy_id === null ? 'NULL' : image.toy_id
            ].join(',')})`
        }).join(',\n');

        return `INSERT INTO \`image\` (${fields.map(f => `\`${f}\``).join(',')}) VALUES\n${values};`;
    }
}