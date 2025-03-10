import {OrderStatusHistoryPool} from "../../pool/order_status_history";
import {OrderState, OrderStatusHistory} from "../../model/OrderStatusHistory";
import {NotificationPool} from "../../pool/notification";
import {Notification} from "../../model/Notification";
import { OrderPool } from "../../pool/order";

export function completeOrderPrepare(date: Date) {
  const orderIds = OrderStatusHistoryPool.pickAllOrderWithLatestState(date, OrderState.PREPARING);

  for (const orderId of orderIds) {
    const order = OrderPool.getById(orderId);

    if (!order) {
      continue;
    }

    OrderStatusHistoryPool.add(new OrderStatusHistory({
      createdAt: date,
      id: OrderStatusHistoryPool.getNextId(),
      orderId: orderId,
      state: OrderState.READY_FOR_PICKUP
    }));

    order.latest_status = OrderState.READY_FOR_PICKUP

    NotificationPool.add(new Notification({
      account_id: order.account_id,
      created_at: date,
      is_read: false,
      message: `Your order #${orderId} has been packaged. Please waiting for shipping!`,
      notification_id: NotificationPool.getNextId(),
      updated_at: date
    }))
  }
}