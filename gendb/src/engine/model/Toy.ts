import { escapeSingleQuotes } from "../utils.js";

export enum ToyRarity {
    REGULAR = 'REGULAR',
    SECRET = 'SECRET'
}

export class Toy {
    toyId: number;
    createdAt: Date;
    description: string;
    isVisible: boolean;
    name: string;
    rarity: ToyRarity;
    updatedAt: Date;
    weight: number;
    blindBoxId: number;

    constructor(init: Partial<Toy>) {
        this.toyId = init.toyId ?? 0;
        this.createdAt = init.createdAt ?? new Date();
        this.description = init.description ?? '';
        this.isVisible = init.isVisible ?? true;
        this.name = init.name ?? '';
        this.rarity = init.rarity ?? ToyRarity.REGULAR;
        this.updatedAt = init.updatedAt ?? new Date();
        this.weight = init.weight ?? 0;
        this.blindBoxId = init.blindBoxId ?? 0;
    }

    static dump(toys: Toy[]): string {
        if (!toys.length) return '';

        const fields = [
            'toy_id',
            'created_at',
            'description',
            'is_visible',
            'name',
            'rarity',
            'updated_at',
            'weight',
            'blind_box_id'
        ];

        const values = toys.map(toy => {
            const formattedCreatedAt = toy.createdAt.toISOString().slice(0, 19).replace('T', ' ') + '.000000';
            const formattedUpdatedAt = toy.updatedAt.toISOString().slice(0, 19).replace('T', ' ') + '.000000';

            return `(${toy.toyId},` +
                   `'${formattedCreatedAt}',` +
                   `'${escapeSingleQuotes(toy.description)}',` +
                   `${toy.isVisible ? 1 : 0},` +
                   `'${escapeSingleQuotes(toy.name)}',` +
                   `'${toy.rarity}',` +
                   `'${formattedUpdatedAt}',` +
                   `${toy.weight.toFixed(2)},` +
                   `${toy.blindBoxId})`;
        }).join(',\n');

        return `INSERT INTO \`toy\` (${fields.join(', ')}) VALUES\n${values};`;
    }
}