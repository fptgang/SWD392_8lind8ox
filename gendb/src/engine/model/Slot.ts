import {Set} from "./Set";

export class Slot {
    slotId: number;
    createdAt: Date;
    isOpened: boolean;
    isVisible: boolean;
    position: number;
    updatedAt: Date | null;
    setId: number | null;
    toyId: number | null;

    // convenient fields, do not dump
    set: Set | null = null;

    constructor(data: Partial<Slot> = {}) {
        this.slotId = data.slotId ?? 0;
        this.createdAt = data.createdAt ?? new Date();
        this.isOpened = data.isOpened ?? true;
        this.isVisible = data.isVisible ?? true;
        this.position = data.position ?? 0;
        this.updatedAt = data.updatedAt ?? null;
        this.setId = data.setId ?? null;
        this.toyId = data.toyId ?? null;
        this.set = data.set ?? null;
    }

    static dump(slots: Slot[]): string {
        if (slots.length === 0) return "";

        const fields = [
            'slot_id',
            'created_at',
            'is_opened',
            'is_visible',
            'position',
            'updated_at',
            'set_id',
            'toy_id',
        ];

        const values = slots.map(slot => {
            const formattedValues = [
                slot.slotId,
                slot.createdAt ? `'${slot.createdAt.toISOString().slice(0, 19)}.000000'` : 'NULL',
                slot.isOpened ? 1 : 0,
                slot.isVisible ? 1 : 0,
                slot.position,
                slot.updatedAt ? `'${slot.updatedAt.toISOString().slice(0, 19)}.000000'` : 'NULL',
                slot.setId ?? 'NULL',
                slot.toyId ?? 'NULL'
            ];
            return `(${formattedValues.join(',')})`;
        });

        return `INSERT INTO slots (${fields.join(',')}) VALUES\n${values.join(',\n')};`;
    }
}