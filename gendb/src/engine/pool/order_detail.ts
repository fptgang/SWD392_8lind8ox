import {SqlFileAppender} from "../appender";
import {OrderDetail} from "../model/OrderDetail";

export class orderDetailPool {
  private orderDetails: OrderDetail[] = [];
  private nextId: number = 1;

  add(orderDetail: OrderDetail) {
    this.orderDetails.push(orderDetail);
  }

  getNextId(): number {
    return this.nextId++;
  }

  dump(): string {
    return '\n' + OrderDetail.dump(this.orderDetails);
  }

  count(): number {
    return this.orderDetails.length;
  }
}

export let OrderDetailPool = new orderDetailPool();
export const DumpOrderDetails = () => SqlFileAppender.append(OrderDetailPool.dump());
export const ResetOrderDetailPool = () => {
  OrderDetailPool = new orderDetailPool();
}