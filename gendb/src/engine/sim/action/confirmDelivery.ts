
import {OrderStatusHistoryPool} from "../../pool/order_status_history";
import {OrderState, OrderStatusHistory} from "../../model/OrderStatusHistory";
import {NotificationPool} from "../../pool/notification";
import {Notification} from "../../model/Notification";
import { OrderPool } from "../../pool/order";

export function confirmDelivery(date: Date) {
  const orderIds = OrderStatusHistoryPool.pickAllOrderWithLatestState(date, OrderState.DELIVERED);

  for (const orderId of orderIds) {
    OrderStatusHistoryPool.add(new OrderStatusHistory({
      createdAt: date,
      id: OrderStatusHistoryPool.getNextId(),
      orderId: orderId,
      state: OrderState.RECEIVED
    }));

    const order = OrderPool.getById(orderId);

    if (!order) {
      continue;
    }

    NotificationPool.add(new Notification({
      account_id: order.account_id,
      created_at: date,
      is_read: false,
      message: `You have confirmed the delivery for order #${orderId}. Thank you for your purchase!`,
      notification_id: NotificationPool.getNextId(),
      updated_at: date
    }))
  }
}