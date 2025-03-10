import {escapeSingleQuotes} from "../utils.js";
import { Slot } from "./Slot.js";

export class Video {
    videoId: number;
    createdAt: Date;
    description: string;
    isVerified: boolean;
    isVisible: boolean;
    updatedAt: Date | null;
    url: string;
    accountId: number | null;


    // convenient fields, do not dump
    slot: Slot | null = null;


    constructor(init: Partial<Video>) {
        this.videoId = init.videoId ?? 0;
        this.createdAt = init.createdAt ?? new Date();
        this.description = init.description ?? '';
        this.isVerified = init.isVerified ?? false;
        this.isVisible = init.isVisible ?? true;
        this.updatedAt = init.updatedAt ?? null;
        this.url = init.url ?? '';
        this.accountId = init.accountId ?? null;
        this.slot = init.slot ?? null;
    }

    static dump(videos: Video[]): string {
        if (videos.length === 0) return '';

        const fields = [
            'video_id',
            'created_at',
            'description',
            'is_verified',
            'is_visible',
            'updated_at',
            'url',
            'account_id'
        ];

        const values = videos.map(video => {
            const row = [
                video.videoId,
                video.createdAt ? `'${video.createdAt.toISOString().slice(0, 19)}.000000'` : 'NULL',
                `'${escapeSingleQuotes(video.description)}'`,
                video.isVerified ? 1 : 0,
                video.isVisible ? 1 : 0,
                video.updatedAt ? `'${video.updatedAt.toISOString().slice(0, 19)}.000000'` : 'NULL',
                `'${escapeSingleQuotes(video.url)}'`,
                video.accountId ?? 'NULL'
            ];
            return `(${row.join(', ')})`;
        });

        return `INSERT INTO \`videos\` (${fields.map(f => '`' + f + '`').join(', ')}) VALUES\n${values.join(',\n')};`;
    }
}