import {faker} from "@faker-js/faker";
import {Order} from "../../model/Order";
import {
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
import {Slot, SlotState} from "../../model/Slot";
import {Sku} from "../../model/Sku";
import {BlindBoxCampaignPool} from "../../pool/blindbox_campaign";
import {VoucherPool} from "../../pool/voucher";
import {ShippingInfoPool} from "../../pool/shipping_info";
import {ShippingInfo} from "../../model/ShippingInfo";
import {OrderStatusHistoryPool} from "../../pool/order_status_history";
import {OrderState, OrderStatusHistory} from "../../model/OrderStatusHistory";
import {TransactionPool} from "../../pool/transaction";
import {
  PaymentMethod,
  Transaction,
  TransactionStatus,
  TransactionType
} from "../../model/Transaction";
import {NotificationPool} from "../../pool/notification";
import {Notification} from "../../model/Notification";
import {VoucherState} from "../../model/Voucher";

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
    const quantity = faker.number.int(normalProductBuyQuantity());
    if (quantity > sku.stock) continue
    items.push({
      sku,
      quantity,
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

  const account = AccountPool.pickAccount(date, AccountRole.CUSTOMER)
  if (!account) return

  const details = cart.map(item => {
    if (!item.sku) return null;

    const subTotal = item.sku.price * item.quantity;
    let checkoutPrice = subTotal;

    // Apply promotional campaign discount
    const blindBoxId = item.sku?.blindBoxId;
    let campaignId: number | undefined = undefined
    if (blindBoxId){
      const blindBoxCampaign = BlindBoxCampaignPool.pickActiveBlindBoxCampaign(date, blindBoxId)
      campaignId = blindBoxCampaign?.promotional_campaign_id
      if (blindBoxCampaign && blindBoxCampaign.campaign) {
        const discount = subTotal * blindBoxCampaign.campaign.discountRate;
        checkoutPrice -= discount
      }
    }

    return new OrderDetail({
      sku_id: item.sku?.skuId,
      sku: item.sku,
      unit_price: item.sku?.price,
      final_total: checkoutPrice,
      sub_total: subTotal,
      quantity: item.quantity,
      slot_id: item.slot?.slotId,
      campaign_id: campaignId,
      updated_at: date,
      created_at: date,
      slot: item.slot
    })
  }).filter((e): e is OrderDetail => e !== null)

  const originalTotalPrice = details.reduce((acc, detail) => acc + detail.final_total, 0)
  let finalTotal = originalTotalPrice

  // Apply voucher discount
  const voucher = VoucherPool.pickUnusedVoucher(date, account.account_id)
  if (voucher) {
    const discountPrice = Math.min(originalTotalPrice * voucher.discountRate, voucher.limitAmount)
    finalTotal = Math.max(finalTotal - discountPrice, 0)
  }

  ////////////////////////////////////////////////////////////////

  // Deposit credits if not enough
  if (account.balance < finalTotal) {
    if (!TransactionPool.deposit(date, account, finalTotal - account.balance)) {
      console.log(`Order is skipped because of failing to deposit credits`)
      return;
    }
  }

  ////////////////////////////////////////////////////////////////

  // Pick or create shipping info
  const shippingInfo = pickOrCreateShippingInfo(date, account.account_id)

  // Create order
  const orderId = OrderPool.getNextId()
  const order = new Order({
    order_id: orderId,
    account_id: account.account_id,
    final_total: finalTotal,
    sub_total: originalTotalPrice,
    shipping_info_id: shippingInfo.shipping_info_id,
    updated_at: date,
    created_at: date,
    latest_status: OrderState.PREPARING,
    details
  })
  OrderPool.add(order)

  // Create order details
  for (const detail of details) {
    detail.order_detail_id = OrderDetailPool.getNextId()
    detail.order_id = orderId
    OrderDetailPool.add(detail)
  }

  // Create order status history
  OrderStatusHistoryPool.add(new OrderStatusHistory({
    createdAt: date,
    id: OrderStatusHistoryPool.getNextId(),
    orderId: orderId,
    state: OrderState.CREATED
  }))

  // Using internal wallet, the order is paid immediately
  OrderStatusHistoryPool.add(new OrderStatusHistory({
    createdAt: new Date(date.getTime() + 1),
    id: OrderStatusHistoryPool.getNextId(),
    orderId: orderId,
    state: OrderState.PREPARING
  }))

  // Use voucher
  if (voucher) {
    voucher.state = VoucherState.USED
    voucher.updatedAt = date
    voucher.orderId = orderId
    order.voucher = voucher
  }

  // Update slots
  for (const detail of details) {
    if (!detail.slot) continue
    detail.slot.state = SlotState.OPENED
    detail.slot.openedAt = date
    detail.slot.updatedAt = date
  }

  // Update SKU stock
  for (const detail of details) {
    if (!detail.sku) continue
    detail.sku.stock -= detail.quantity
    detail.sku.updatedAt = date
  }

  // Create transaction
  TransactionPool.add(new Transaction({
    account_id: account.account_id,
    amount: order.final_total,
    created_at: date,
    updated_at: date,
    new_balance: account.balance - order.final_total,
    old_balance: account.balance,
    order_id: orderId,
    payment_method: PaymentMethod.INTERNAL_WALLET,
    status: TransactionStatus.SUCCESS,
    transaction_id: TransactionPool.getNextId(),
    type: TransactionType.ORDER
  }))

  account.balance -= order.final_total
  account.update_balance_at = date

  // Create notification
  NotificationPool.add(new Notification({
    account_id: account.account_id,
    created_at: date,
    is_read: false,
    message: `You have spent \$${order.final_total} on order #${orderId}. Your new balance is \$${account.balance}`,
    notification_id: NotificationPool.getNextId(),
    updated_at: date
  }))
  NotificationPool.add(new Notification({
    account_id: account.account_id,
    created_at: date,
    is_read: false,
    message: `Your order #${orderId} has been successfully placed. The staff is preparing your order!`,
    notification_id: NotificationPool.getNextId(),
    updated_at: date
  }))
}