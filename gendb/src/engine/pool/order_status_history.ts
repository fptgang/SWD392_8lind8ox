import {SqlFileAppender} from "../appender";
import {OrderState, OrderStatusHistory} from "../model/OrderStatusHistory";

export class orderStatusHistoryPool {
  private orderStatusHistories: OrderStatusHistory[] = [];
  private nextId: number = 1;

  add(orderStatusHistory: OrderStatusHistory) {
    this.orderStatusHistories.push(orderStatusHistory);
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + OrderStatusHistory.dump(this.orderStatusHistories);
  }

  pickAllOrderWithLatestState(date: Date, state: OrderState): number[] {
    const filteredHistories = this.orderStatusHistories.filter(
      (history) => history.createdAt <= date
    );

    if (filteredHistories.length === 0) {
      return [];
    }

    const latestHistoryMap = new Map<number, OrderStatusHistory>();

    for (const history of filteredHistories) {
      const existing = latestHistoryMap.get(history.orderId);
      if (!existing || history.createdAt > existing.createdAt) {
        latestHistoryMap.set(history.orderId, history);
      }
    }


    return Array.from(latestHistoryMap.values())
      .filter((history) => history.state === state)
      .map((history) => history.orderId);
  }

  count(): number {
    return this.orderStatusHistories.length;
  }
}

export let OrderStatusHistoryPool = new orderStatusHistoryPool();
export const DumpOrderStatusHistories = () => SqlFileAppender.append(OrderStatusHistoryPool.dump());
export const ResetOrderStatusHistoryPool = () => {
  OrderStatusHistoryPool = new orderStatusHistoryPool();
}
