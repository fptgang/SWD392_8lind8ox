```
Place order
- create OrderDetail -> Slot
- create Order
- create OrderStatusHistory: CREATED
- Reduce SKU

By internal
- Deduct balance
- create ORDER transaction SUCCESS
- update Voucher -> USED
- update Slot -> OPENED
- create OrderStatusHistory: PREPARING

By external
- create DEPOSIT transaction PENDING
- create ORDER transaction PENDING
- update Voucher -> RESERVED
- update Slot -> RESERVED

=====================================
Order Payment Callback
- Mark DEPOSIT transaction SUCCESS/FAILED

* Failed
- Cancel Order for <<REASON: PAYMENT_FAILED>>

* Success
- Deduct balance
- update ORDER transaction SUCCESS
- update Voucher -> USED
- update Slot -> OPENED
- create OrderStatusHistory: PREPARIING

=====================================
Cancel Order for <<REASON>>
- update ORDER transaction FAILED
- update Voucher -> AVAILABLE
- update Slot -> AVAILABLE
- restock SKU
- create OrderStatusHistory: <<REASON>>
- Do not deduct balance here because order can only be cancelled before paid

```