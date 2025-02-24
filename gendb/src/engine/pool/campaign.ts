import {SqlFileAppender} from "../appender";
import { PromotionalCampaign } from "../model/PromotionalCampaign";

export class promotionalCampaignPool {
  private campaigns: PromotionalCampaign[] = [];
  private nextId: number = 1;

  add(promotionalCampaign: PromotionalCampaign) {
    this.campaigns.push(promotionalCampaign);
  }

  pickPromotionalCampaign(date: Date, campaignId: number): PromotionalCampaign | null {
    const eligible = this.campaigns.filter(promotionalCampaign => {
      const matchesDate = promotionalCampaign.createdAt <= date;
      const isVisible = promotionalCampaign.isVisible;
      const matchesCampaignId = promotionalCampaign.campaignId === campaignId;
      return matchesDate && isVisible && matchesCampaignId;
    });

    if (eligible.length === 0) return null;

    const randomIndex = Math.floor(Math.random() * eligible.length);
    return eligible[randomIndex];
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + PromotionalCampaign.dump(this.campaigns);
  }

  count(): number {
    return this.campaigns.length;
  }
}

export let PromotionalCampaignPool = new promotionalCampaignPool();
export const DumpCampaigns = () => SqlFileAppender.append(PromotionalCampaignPool.dump());

export const ResetPromotionalCampaignPool = () => {
    PromotionalCampaignPool = new promotionalCampaignPool();
}
