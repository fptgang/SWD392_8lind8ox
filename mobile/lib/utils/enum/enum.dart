enum AuthenticationStatus { unknown, authenticated, unauthenticated }

enum UniLinksType { string, uri }

enum OrderStatusHistoryEnum {
  CREATED,
  COURIER_ACCEPTED,
  SHIPPING,
  DELIVERED,
  RECEIVED,
  COMPLETED
}

enum OrderStatusEnum {
  CREATED,
  PREPARING,
  PAYMENT_FAILED,
  PAYMENT_EXPIRED,
  CANCELED,
  READY_FOR_PICKUP,
  SHIPPING,
  DELIVERED,
  RECEIVED,
  COMPLETED,
}

enum TransactionType { DEPOSIT, ORDER }

enum PaymentMethod { PAYPAL, VNPAY }

enum ToyRarityEnum { REGULAR, SECRET }

enum AccountEnum { USER, ADMIN }

enum TransactionStatusEnum {
  PENDING,
  SUCCESS,
  FAILED,
}

enum SlotStateEnum {
  OPENED,
  AVAILABLE,
  RESERVED,
}

enum VoucherStatusEnum {
  USED,
  AVAILABLE,
  RESERVED,
}

enum CartPaymentMethodEnum {
  INTERNAL_WALLET,
  PAYPAL,
  VNPAY,
}
