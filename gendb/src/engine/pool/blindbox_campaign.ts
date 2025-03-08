import {SqlFileAppender} from "../appender";
import { BlindBoxCampaign } from "../model/BlindBoxCampaign";
import { PromotionalCampaignPool } from "./campaign";

export class blindBoxCampaignPool {
  private blindBoxCampaigns: BlindBoxCampaign[] = [];

  add(blindBoxCampaign: BlindBoxCampaign) {
    this.blindBoxCampaigns.push(blindBoxCampaign);
  }

  pickActiveBlindBoxCampaign(date: Date, blindBoxId: number): BlindBoxCampaign | null {
    const eligible = this.blindBoxCampaigns.filter(blindBoxCampaign => {
      const matchesDate = blindBoxCampaign.created_at <= date;
      const isVisible = blindBoxCampaign.is_visible;
      const matchesBlindBoxId = blindBoxCampaign.blind_box_id === blindBoxId;
      const promotionalCampaign = PromotionalCampaignPool.pickPromotionalCampaign(date, blindBoxCampaign.promotional_campaign_id);
      if (!promotionalCampaign)
        return false;
      const nonExpired = promotionalCampaign.startDate <= date && promotionalCampaign.endDate >= date;
      return matchesDate && isVisible && matchesBlindBoxId && nonExpired;
    });

    if (eligible.length === 0) return null;

    const randomIndex = Math.floor(Math.random() * eligible.length);
    return eligible[randomIndex];
  }

  dump(): string {
    return '\n' + BlindBoxCampaign.dump(this.blindBoxCampaigns);
  }

  count(): number {
    return this.blindBoxCampaigns.length;
  }
}

export let BlindBoxCampaignPool = new blindBoxCampaignPool();
export const DumpBlindBoxCampaigns = () => SqlFileAppender.append(BlindBoxCampaignPool.dump());

export const ResetBlindBoxCampaignPool = () => {
  BlindBoxCampaignPool = new blindBoxCampaignPool();
}
