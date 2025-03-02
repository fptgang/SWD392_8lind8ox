import { PromotionalCampaign } from "../../model/PromotionalCampaign";
import {PromotionalCampaignPool} from "../../pool/campaign";
import {
    campaignDescriptionLines,
    campaignDiscountRate,
    campaignDurationDays, campaignMaxBlindBoxes,
    campaignScheduleBeforeDays
} from "../../config";
import {faker} from "@faker-js/faker";
import {BlindBoxPool} from "../../pool/blindbox";
import {BlindBoxCampaign} from "../../model/BlindBoxCampaign";
import {BlindBoxCampaignPool} from "../../pool/blindbox_campaign";

export function launchCampaign(date: Date) {
    const startDate = new Date(date.getTime() + faker.number.int(campaignScheduleBeforeDays()) * 60 * 60 * 1000);
    const endDate = new Date(startDate.getTime() + faker.number.int(campaignDurationDays()) * 24 * 60 * 60 * 1000);

    const eligibles = BlindBoxPool.pickMultiBlindBox(date, faker.number.int(campaignMaxBlindBoxes()))
    if (eligibles.length === 0) return;

    const campaign = new PromotionalCampaign({
        campaignId: PromotionalCampaignPool.getNextId(),
        createdAt: date,
        description: faker.lorem.paragraph(campaignDescriptionLines()),
        discountRate: faker.number.float(campaignDiscountRate()),
        endDate: endDate,
        isVisible: true,
        startDate: startDate,
        title: faker.lorem.words() + " SALE",
        updatedAt: date
    })

    PromotionalCampaignPool.add(campaign);

    for (let eligible of eligibles) {
        const blindBoxCampaign = new BlindBoxCampaign({
            campaign,
            blind_box_id: eligible.blind_box_id,
            created_at: date,
            updated_at: date,
            history_id: BlindBoxCampaignPool.getNextId(),
            is_visible: true,
            promotional_campaign_id: campaign.campaignId
        })

        BlindBoxCampaignPool.add(blindBoxCampaign);
    }
}
