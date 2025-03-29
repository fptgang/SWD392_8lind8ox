import {PromotionalCampaign} from "./PromotionalCampaign";

export class BlindBoxCampaign {
    // created_at: Date;
    // updated_at: Date | null;
    // is_visible: boolean;
    blind_box_id: number;
    promotional_campaign_id: number;

    // convenient fields, do not dump
    campaign: PromotionalCampaign | null = null;

    constructor(data: Partial<BlindBoxCampaign>) {
        // this.created_at = data.created_at || new Date();
        // this.updated_at = data.updated_at || null;
        // this.is_visible = data.is_visible ?? true;
        this.blind_box_id = data.blind_box_id || 0;
        this.promotional_campaign_id = data.promotional_campaign_id || 0;
        this.campaign = data.campaign || null;
    }

    static dump(models: BlindBoxCampaign[]): string {
        if (models.length === 0) return '';

        const fields = [
            // 'created_at',
            // 'updated_at',
            // 'is_visible',
            'blind_box_id',
            'promotional_campaign_id'
        ];

        const values = models.map(model => {
            return `(${[
                // model.created_at ? `'${model.created_at.toISOString().slice(0, 19)}.000000'` : 'NULL',
                // model.updated_at ? `'${model.updated_at.toISOString().slice(0, 19)}.000000'` : 'NULL',
                // model.is_visible ? 1 : 0,
                model.blind_box_id,
                model.promotional_campaign_id
            ].join(',')})`
        }).join(',\n');

        return `INSERT INTO \`blind_box_campaign\` (${fields.map(f => `\`${f}\``).join(',')}) VALUES\n${values};`;
    }
}