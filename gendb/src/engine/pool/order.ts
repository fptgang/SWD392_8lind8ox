import {SqlFileAppender} from "../appender";
import {Order} from "../model/Order";

export class orderPool {
  private orders: Order[] = [];
  private ordersById: Map<number, Order> = new Map();
  private nextId: number = 1;

  add(order: Order) {
    this.orders.push(order);
    this.ordersById.set(order.order_id, order);
  }

  getById(id: number): Order | null {
    return this.ordersById.get(id) || null;
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + Order.dump(this.orders);
  }

  count(): number {
    return this.orders.length;
  }
}

export let OrderPool = new orderPool();
export const DumpOrders = () => SqlFileAppender.append(OrderPool.dump());
export const ResetOrderPool = () => {
  OrderPool = new orderPool();
}