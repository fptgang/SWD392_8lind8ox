import {Sku} from "../model/Sku";
import {SqlFileAppender} from "../appender";
import {shuffle} from "../utils";

export class skuPool {
  private skus: Sku[] = [];
  private nextId: number = 1;

  add(sku: Sku) {
    this.skus.push(sku);
  }

  pickSku(date: Date, minSpecCount: number): Sku | null {
    const eligible = this.skus.filter(sku => {
      const matchesDate = sku.createdAt <= date;
      const isVisible = sku.isVisible;
      const matchesSpecCount = sku.specCount >= minSpecCount;
      return matchesDate && isVisible && matchesSpecCount;
    });

    if (eligible.length === 0) return null;

    const randomIndex = Math.floor(Math.random() * eligible.length);
    return eligible[randomIndex];
  }

  pickMultiSkus(date: Date, limit: number): Sku[] {
    const eligible = this.skus.filter(sku => {
      const matchesDate = sku.createdAt <= date;
      const isVisible = sku.isVisible;
      return matchesDate && isVisible;
    });
    shuffle(eligible);

    if (eligible.length <= limit) return eligible;
    return eligible.slice(0, limit);
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + Sku.dump(this.skus);
  }

  count(): number {
    return this.skus.length;
  }
}

export let SkuPool = new skuPool();
export const DumpSkus = () => SqlFileAppender.append(SkuPool.dump());

export const ResetSkuPool = () => {
  SkuPool = new skuPool();
}
