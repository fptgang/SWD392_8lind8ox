import {OrderStatusHistoryPool} from "../../pool/order_status_history";
import {OrderState, OrderStatusHistory} from "../../model/OrderStatusHistory";
import {NotificationPool} from "../../pool/notification";
import {Notification} from "../../model/Notification";
import { OrderPool } from "../../pool/order";

export function contactDeliveryPartner(date: Date) {
  const orderIds = OrderStatusHistoryPool.pickAllOrderWithLatestState(date, OrderState.CREATED);

  for (const orderId of orderIds) {
    OrderStatusHistoryPool.add(new OrderStatusHistory({
      createdAt: date,
      id: OrderStatusHistoryPool.getNextId(),
      orderId: orderId,
      state: OrderState.COURIER_ACCEPTED
    }));

    const order = OrderPool.getById(orderId);

    if (!order) {
      continue;
    }

    NotificationPool.add(new Notification({
      account_id: order.account_id,
      created_at: date,
      is_read: false,
      message: `Your order #${orderId} has been transferred to courier. Please waiting for confirmation on shipping!`,
      notification_id: NotificationPool.getNextId(),
      updated_at: date
    }))
  }
}