import {faker} from "@faker-js/faker";
import {Order} from "../../model/Order";
import {
  cancelOrderRatio,
  forceCreateShippingInfoChance,
  gachaSlotBuyPerOrder,
  normalProductBuyPerOrder,
  normalProductBuyQuantity
} from "../../config";
import {SkuPool} from "../../pool/sku";
import {SlotPool} from "../../pool/slot";
import {AccountPool} from "../../pool/account";
import {AccountRole} from "../../model/Account";
import {OrderPool} from "../../pool/order";
import {OrderDetail} from "../../model/OrderDetail";
import {OrderDetailPool} from "../../pool/order_detail";
import {Slot} from "../../model/Slot";
import {Sku} from "../../model/Sku";
import {BlindBoxCampaignPool} from "../../pool/blindbox_campaign";
import {VoucherPool} from "../../pool/voucher";
import {ShippingInfoPool} from "../../pool/shipping_info";
import {ShippingInfo} from "../../model/ShippingInfo";
import {OrderStatusHistoryPool} from "../../pool/order_status_history";
import {OrderState, OrderStatusHistory} from "../../model/OrderStatusHistory";
import {TransactionPool} from "../../pool/transaction";
import {Transaction, TransactionType} from "../../model/Transaction";
import {NotificationPool} from "../../pool/notification";
import {Notification} from "../../model/Notification";

class CartItem {
  sku: Sku | null = null;
  slot: Slot | null = null;
  quantity!: number;
}

function createCart(date: Date): CartItem[] {
  const items: CartItem[] = [];

  // NORMAL PURCHASE
  const skus = SkuPool.pickMultiSkus(date, faker.number.int(normalProductBuyPerOrder()))
  
  for(const sku of skus) {
    items.push({
      sku,
      quantity: faker.number.int(normalProductBuyQuantity()),
      slot: null
    } as CartItem);
  }

  // GACHA SLOT PURCHASES
  const slots = SlotPool.pickMultiEmptySlots(date, faker.number.int(gachaSlotBuyPerOrder()))

  for (let slot of slots) {
    items.push({
      skuId: slot.set?.sku_id,
      quantity: 1,
      slot,
      sku: slot.set?.sku
    } as CartItem);
  }

  return items
}

function pickOrCreateShippingInfo(date: Date, accountId: number): ShippingInfo {
  let shippingInfo;

  if (faker.number.float({min: 0, max: 1}) > forceCreateShippingInfoChance()) {
    shippingInfo = ShippingInfoPool.pickShippingInfo(date, accountId)
    if (shippingInfo) 
      return shippingInfo
  }

    shippingInfo = new ShippingInfo({
        shipping_info_id: ShippingInfoPool.getNextId(),
        address: faker.location.streetAddress(),
        city: faker.location.city(),
        created_at: date,
        district: faker.location.county(),
        is_visible: true,
        name: faker.person.fullName(),
        phone_number: faker.phone.number(),
        updated_at: date,
        ward: faker.location.street(),
        account_id: accountId
    })

  ShippingInfoPool.add(shippingInfo)

  return shippingInfo
}

export function checkout(date: Date) {
  const cart = createCart(date)
  if (cart.length === 0) return

  const account = AccountPool.pickAccount(date, AccountRole.CUSTOMER, false)
  if (!account) return

  const orderId = OrderPool.getNextId()

  const details = cart.map(item => {
    const originalPrice = item.sku?.price;
    if (!originalPrice) return null;

    let checkoutPrice = originalPrice

    // Apply promotional campaign discount
    const blindBoxId = item.sku?.blindBoxId;
    let campaignId: number | undefined = undefined
    if (blindBoxId){
      const campaign = BlindBoxCampaignPool.pickActiveBlindBoxCampaign(date, blindBoxId)
      campaignId = campaign?.promotional_campaign_id
      if (campaign) {
        checkoutPrice *= campaign.promotional_campaign_id
      }
    }

    return new OrderDetail({
      order_id: orderId,
      order_detail_id: OrderDetailPool.getNextId(),
      sku_id: item.sku?.skuId,
      checkout_price: checkoutPrice,
      original_price: originalPrice,
      quantity: item.quantity,
      slot_id: item.slot?.slotId,
      campaign_id: campaignId,
      updated_at: date,
      created_at: date,
      slot: item.slot
    })
  }).filter((e): e is OrderDetail => e !== null)

  const originalTotalPrice = details.reduce((acc, detail) => acc + detail.checkout_price * detail.quantity, 0)
  let totalPrice = originalTotalPrice

  // Apply voucher discount
  const voucher = VoucherPool.pickUnusedVoucher(date, account.account_id)
  if (voucher) {
    const discountPrice = Math.min(originalTotalPrice * voucher.discountRate, voucher.limitAmount)
    totalPrice = Math.max(totalPrice - discountPrice, 0)
  }

  ////////////////////////////////////////////////////////////////

  // Pick or create shipping info
  const shippingInfo = pickOrCreateShippingInfo(date, account.account_id)

  // Create order
  const order = new Order({
    order_id: orderId,
    account_id: account.account_id,
    checkout_price: totalPrice,
    original_price: originalTotalPrice,
    shipping_info_id: shippingInfo.shipping_info_id,
    updated_at: date,
    created_at: date,
    details
  })

  OrderPool.add(order)

  // Create order details
  for (const detail of details) {
    OrderDetailPool.add(detail)
  }

  // Create order status history
  OrderStatusHistoryPool.add(new OrderStatusHistory({
    createdAt: date,
    id: OrderStatusHistoryPool.getNextId(),
    orderId: orderId,
    state: OrderState.CREATED
  }))

  let orderOk = faker.number.float() > cancelOrderRatio()

  // Deposit credits if not enough
  if (orderOk && account.balance < totalPrice) {
    if (!TransactionPool.deposit(date, account, totalPrice - account.balance)) {
      orderOk = false
      console.log(`Order #${orderId} is canceled because of failing to deposit credits`)
    }
  }

  ////////////////////////////////////////////////////////////////

  // If not okay:
  if (!orderOk) {
    // Create order status history
    OrderStatusHistoryPool.add(new OrderStatusHistory({
      createdAt: date,
      id: OrderStatusHistoryPool.getNextId(),
      orderId: orderId,
      state: OrderState.CANCELED
    }))
    return;
  }

  ////////////////////////////////////////////////////////////////

  // Use voucher only if order is ok
  if (voucher) {
    voucher.isUsed = true
    voucher.updatedAt = date
    voucher.orderId = orderId
  }

  // Create transaction
  TransactionPool.add(new Transaction({
    account_id: account.account_id,
    amount: order.checkout_price,
    created_at: date,
    new_balance: account.balance - order.checkout_price,
    old_balance: account.balance,
    order_id: orderId,
    payment_method: undefined,
    success: true,
    transaction_id: TransactionPool.getNextId(),
    type: TransactionType.ORDER
  }))

  account.balance -= order.checkout_price
  account.update_balance_at = date

  // Create notification
  NotificationPool.add(new Notification({
    account_id: account.account_id,
    created_at: date,
    is_read: false,
    message: `You have spent \$${order.checkout_price} on order #${orderId}. Your new balance is \$${account.balance}`,
    notification_id: NotificationPool.getNextId(),
    updated_at: date
  }))
  NotificationPool.add(new Notification({
    account_id: account.account_id,
    created_at: date,
    is_read: false,
    message: `Your order #${orderId} has been successfully placed. Please waiting for confirmation on shipping!`,
    notification_id: NotificationPool.getNextId(),
    updated_at: date
  }))

  // Update slots
  for (const detail of details) {
    if (!detail.slot) continue
    detail.slot.isOpened = true
    detail.slot.updatedAt = date
  }
}