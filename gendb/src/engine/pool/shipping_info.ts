import {SqlFileAppender} from "../appender";
import {ShippingInfo} from "../model/ShippingInfo";

export class shippingInfoPool {
  private shippingInfos: ShippingInfo[] = [];
  private nextId: number = 1;

  add(shippingInfo: ShippingInfo) {
    this.shippingInfos.push(shippingInfo);
  }

  pickShippingInfo(date: Date, accountId: number): ShippingInfo | null {
    const eligible = this.shippingInfos.filter(shippingInfo => {
      const matchesDate = shippingInfo.created_at <= date;
      const matchesAccountId = shippingInfo.account_id === accountId;
      const isVisible = shippingInfo.is_visible;
      return matchesDate && matchesAccountId && isVisible;
    });

    if (eligible.length === 0) return null;

    const randomIndex = Math.floor(Math.random() * eligible.length);
    return eligible[randomIndex];
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + ShippingInfo.dump(this.shippingInfos);
  }

  count(): number {
    return this.shippingInfos.length;
  }
}


export let ShippingInfoPool = new shippingInfoPool();
export const DumpShippingInfos = () => SqlFileAppender.append(ShippingInfoPool.dump());
export const ResetShippingInfoPool = () => {
  ShippingInfoPool = new shippingInfoPool();
}
