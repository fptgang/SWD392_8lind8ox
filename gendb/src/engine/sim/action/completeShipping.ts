import {OrderStatusHistoryPool} from "../../pool/order_status_history";
import {OrderState, OrderStatusHistory} from "../../model/OrderStatusHistory";
import {NotificationPool} from "../../pool/notification";
import {Notification} from "../../model/Notification";
import { OrderPool } from "../../pool/order";

export function completeShipping(date: Date) {
  const orderIds = OrderStatusHistoryPool.pickAllOrderWithLatestState(date, OrderState.SHIPPING);

  for (const orderId of orderIds) {
    OrderStatusHistoryPool.add(new OrderStatusHistory({
      createdAt: date,
      id: OrderStatusHistoryPool.getNextId(),
      orderId: orderId,
      state: OrderState.DELIVERED
    }));

    const order = OrderPool.getById(orderId);

    if (!order) {
      continue;
    }

    NotificationPool.add(new Notification({
      account_id: order.account_id,
      created_at: date,
      is_read: false,
      message: `Your order #${orderId} has been delivered. Please confirm the delivery!`,
      notification_id: NotificationPool.getNextId(),
      updated_at: date
    }))
  }
}