import { escapeSingleQuotes } from "../utils.js";

export class PromotionalCampaign {
    campaignId: number;
    createdAt: Date;
    description: string;
    discountRate: number;
    endDate: Date;
    isVisible: boolean;
    startDate: Date;
    title: string;
    updatedAt: Date | null;

    constructor(init: Partial<PromotionalCampaign>) {
        this.campaignId = init.campaignId ?? 0;
        this.createdAt = init.createdAt ?? new Date();
        this.description = init.description ?? '';
        this.discountRate = init.discountRate ?? 0.00;
        this.endDate = init.endDate ?? new Date();
        this.isVisible = init.isVisible ?? true;
        this.startDate = init.startDate ?? new Date();
        this.title = init.title ?? '';
        this.updatedAt = init.updatedAt ?? null;
    }

    static dump(campaigns: PromotionalCampaign[]): string {
        if (campaigns.length === 0) return '';

        const fields = [
            'campaign_id',
            'created_at',
            'description',
            'discount_rate',
            'end_date',
            'is_visible',
            'start_date',
            'title',
            'updated_at'
        ];

        const values = campaigns.map(campaign => {
            return `(${[
                campaign.campaignId,
                campaign.createdAt ? `'${campaign.createdAt.toISOString().slice(0, 19)}.000000'` : 'NULL',
                `'${escapeSingleQuotes(campaign.description)}'`,
                campaign.discountRate.toFixed(2),
                `'${campaign.endDate.toISOString().slice(0, 19)}.000000'`,
                campaign.isVisible ? 1 : 0,
                `'${campaign.startDate.toISOString().slice(0, 19)}.000000'`,
                `'${escapeSingleQuotes(campaign.title)}'`,
                campaign.updatedAt ? `'${campaign.updatedAt.toISOString().slice(0, 19)}.000000'` : 'NULL'
            ].join(', ')})`;
        });

        return `INSERT INTO \`promotional_campaign\` (${fields.map(f => `\`${f}\``).join(', ')}) VALUES\n${values.join(',\n')};`;
    }
}