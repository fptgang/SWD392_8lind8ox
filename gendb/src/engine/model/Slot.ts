import {Set} from "./Set";
import {escapeSingleQuotes} from "../utils";

export enum SlotState {
    OPENED = "OPENED", AVAILABLE = "AVAILABLE", RESERVED = "RESERVED"
}

export class Slot {
    slotId: number;
    createdAt: Date;
    state: SlotState;
    isVisible: boolean;
    position: number;
    updatedAt: Date | null;
    openedAt: Date | null;
    setId: number | null;
    toyId: number | null;

    // convenient fields, do not dump
    set: Set | null = null;

    constructor(data: Partial<Slot> = {}) {
        this.slotId = data.slotId ?? 0;
        this.createdAt = data.createdAt ?? new Date();
        this.state = data.state ?? SlotState.AVAILABLE;
        this.isVisible = data.isVisible ?? true;
        this.position = data.position ?? 0;
        this.updatedAt = data.updatedAt ?? null;
        this.openedAt = data.openedAt ?? null;
        this.setId = data.setId ?? null;
        this.toyId = data.toyId ?? null;
        this.set = data.set ?? null;
    }

    static dump(slots: Slot[]): string {
        if (slots.length === 0) return "";

        const fields = [
            'slot_id',
            'created_at',
            'state',
            'is_visible',
            'position',
            'updated_at',
            'opened_at',
            'set_id',
            'toy_id',
        ];

        const values = slots.map(slot => {
            const formattedValues = [
                slot.slotId,
                slot.createdAt ? `'${slot.createdAt.toISOString().slice(0, 19)}.000000'` : 'NULL',
                `'${escapeSingleQuotes(slot.state)}'`,
                slot.isVisible ? 1 : 0,
                slot.position,
                slot.updatedAt ? `'${slot.updatedAt.toISOString().slice(0, 19)}.000000'` : 'NULL',
                slot.openedAt ? `'${slot.openedAt.toISOString().slice(0, 19)}.000000'` : 'NULL',
                slot.setId ?? 'NULL',
                slot.toyId ?? 'NULL'
            ];
            return `(${formattedValues.join(',')})`;
        });

        return `INSERT INTO slots (${fields.join(',')}) VALUES\n${values.join(',\n')};`;
    }
}