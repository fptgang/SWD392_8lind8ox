package com.fptgang.backend.service.impl;

import com.fptgang.backend.api.model.VoucherDto;
import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.model.*;
import com.fptgang.backend.model.checkout.Cart;
import com.fptgang.backend.model.checkout.PlaceOrderResult;
import com.fptgang.backend.repository.OrderDetailRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.repository.OrderStatusHistoryRepos;
import com.fptgang.backend.service.*;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
@Slf4j
public class OrderServiceImpl implements OrderService {
    private final OrderRepos orderRepos;
    private final OrderStatusHistoryRepos orderStatusHistoryRepos;
    private final OrderDetailRepos orderDetailRepos;
    private final AccountService accountService;
    private final VoucherService voucherService;
    private final StockKeepingUnitService stockKeepingUnitService;
    private final SlotService slotService;
    private final PromotionalCampaignService promotionalCampaignService;
    private final ShippingInfoService shippingInfoService;
    private final TransactionService transactionService;
    private final PaymentService paymentService;

    public OrderServiceImpl(OrderRepos orderRepos,
                            OrderStatusHistoryRepos orderStatusHistoryRepos,
                            OrderDetailRepos orderDetailRepos,
                            AccountService accountService,
                            VoucherService voucherService,
                            StockKeepingUnitService stockKeepingUnitService,
                            SlotService slotService,
                            PromotionalCampaignService promotionalCampaignService,
                            ShippingInfoService shippingInfoService,
                            TransactionService transactionService,
                            PaymentService paymentService
    ) {
        this.orderRepos = orderRepos;
        this.orderStatusHistoryRepos = orderStatusHistoryRepos;
        this.orderDetailRepos = orderDetailRepos;
        this.accountService = accountService;
        this.voucherService = voucherService;
        this.stockKeepingUnitService = stockKeepingUnitService;
        this.slotService = slotService;
        this.promotionalCampaignService = promotionalCampaignService;
        this.shippingInfoService = shippingInfoService;
        this.transactionService = transactionService;
        this.paymentService = paymentService;
    }

    @Override
    @Transactional
    public synchronized PlaceOrderResult place(Cart cart) {
        List<OrderDetail> orderDetails = new ArrayList<>();

        // Validate cart items and create order details
        for (Cart.Item item : cart.getItems()) {
            if (item.getQuantity() <= 0)
                throw new InvalidInputException("Quantity must be positive");

            StockKeepingUnit sku = stockKeepingUnitService.findById(item.getSkuId());
            if (sku == null || !sku.getIsVisible())
                throw new InvalidInputException("StockKeepingUnit not found");
            if (sku.getStock() < item.getQuantity())
                throw new InvalidInputException("Not enough stock on sku " + item.getSkuId());

            Slot slot = null;
            if (item.getSlotId() != null) {
                if (item.getQuantity() != 1)
                    throw new InvalidInputException("Quantity must be 1 for slot purchase");
                slot = slotService.findById(item.getSlotId());
                if (slot == null || !slot.getIsVisible())
                    throw new InvalidInputException("Slot not found");
                if (slot.getSet()
                        .getSku() != sku)
                    throw new InvalidInputException("Slot does not match sku");
                if (slot.getState() == Slot.State.OPENED)
                    throw new InvalidInputException("Slot is already opened");
                if (slot.getState() == Slot.State.RESERVED)
                    throw new InvalidInputException("Slot has been reserved");
            }

            BigDecimal checkoutPrice = sku.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            PromotionalCampaign campaign = promotionalCampaignService
                    .findBestOngoingCampaignForSku(sku.getSkuId());
            if (campaign != null) {
                BigDecimal discount = checkoutPrice.multiply(campaign.getDiscountRate());
                checkoutPrice = checkoutPrice.subtract(discount);
            }

            OrderDetail orderDetail = new OrderDetail();
            orderDetail.setSlot(slot);
            orderDetail.setQuantity(item.getQuantity());
            orderDetail.setPromotionalCampaign(campaign);
            orderDetail.setStockKeepingUnit(sku);
            orderDetail.setOriginalPrice(sku.getPrice());
            orderDetail.setCheckoutPrice(checkoutPrice);
            orderDetails.add(orderDetail);

            log.info("OrderDetail SkuId={}, SlotId={}, Quantity={}, OriginalPrice={}, CheckoutPrice={}",
                    item.getSkuId(),
                    item.getSlotId(),
                    item.getQuantity(),
                    sku.getPrice(),
                    checkoutPrice);
        }

        // Calculate total price
        BigDecimal totalOriginalPrice = orderDetails.stream()
                                                    .map(OrderDetail::getOriginalPrice)
                                                    .reduce(BigDecimal.ZERO,
                                                            BigDecimal::add);
        BigDecimal totalCheckoutPrice = orderDetails.stream()
                                                    .map(OrderDetail::getCheckoutPrice)
                                                    .reduce(BigDecimal.ZERO,
                                                            BigDecimal::add);

        // Validate voucher and update total checkout price
        Voucher voucher = null;
        if (cart.getVoucherId() != null) {
            voucher = voucherService.findById(cart.getVoucherId());
            if (voucher == null)
                throw new InvalidInputException("Voucher not found");
            if (!Objects.equals(voucher.getAccount()
                                       .getAccountId(),
                    cart.getAccountId()))
                throw new InvalidInputException("Voucher does not belong to account");
            if (voucher.getState() == Voucher.State.USED)
                throw new InvalidInputException("Voucher is already used");
            if (voucher.getState() == Voucher.State.RESERVED)
                throw new InvalidInputException("Voucher has been reserved");
            if (voucher.getExpiredAt()
                       .isBefore(LocalDateTime.now()))
                throw new InvalidInputException("Voucher is expired");

            BigDecimal discount = totalCheckoutPrice.multiply(voucher.getDiscountRate());
            discount = discount.min(voucher.getLimitAmount());
            totalCheckoutPrice = totalCheckoutPrice.subtract(discount);
        }

        log.info("Order TotalOriginalPrice={}, TotalCheckoutPrice={}",
                totalOriginalPrice,
                totalCheckoutPrice);

        // Validate account and wallet balance (if using internal wallet)
        Account account = accountService.findById(cart.getAccountId());
        if (account == null)
            throw new InvalidInputException("Account not found");
        if (cart.getPaymentMethod() == Transaction.PaymentMethod.INTERNAL_WALLET) {
            if (account.getBalance()
                       .compareTo(totalCheckoutPrice) < 0) {
                throw new InvalidInputException("Not enough balance");
            }
        }

        // Validate shipping info
        ShippingInfo shippingInfo = shippingInfoService.findById(cart.getShippingInfoId());
        if (shippingInfo == null)
            throw new InvalidInputException("ShippingInfo not found");
        if (!Objects.equals(shippingInfo.getAccount()
                                        .getAccountId(),
                cart.getAccountId()))
            throw new InvalidInputException("ShippingInfo does not belong to account");

        // Create order
        Order order = new Order();
        order.setAccount(account);
        order.setVoucher(voucher);
        order.setShippingInfo(shippingInfo);
        order.setOriginalPrice(totalOriginalPrice);
        order.setCheckoutPrice(totalCheckoutPrice);
        order = orderRepos.save(order);

        // Create order status histories
        OrderStatusHistory orderStatusHistory = new OrderStatusHistory();
        orderStatusHistory.setOrder(order);
        orderStatusHistory.setState(OrderStatusHistory.State.CREATED);
        orderStatusHistory = orderStatusHistoryRepos.save(orderStatusHistory);
        order.setOrderStatusHistories(List.of(orderStatusHistory));

        // Create order details
        for (OrderDetail orderDetail : orderDetails) {
            orderDetail.setOrder(order);
        }
        orderDetails = orderDetailRepos.saveAll(orderDetails);
        order.setOrderDetails(orderDetails);

        return cart.getPaymentMethod() == Transaction.PaymentMethod.INTERNAL_WALLET ?
                payOrderByInternalWallet(order) :
                payOrderByExternalWallet(order,
                        cart.getPaymentMethod());
    }

    private PlaceOrderResult payOrderByInternalWallet(Order order) {
        // Create ORDER transaction
        Transaction orderTransaction = new Transaction();
        orderTransaction.setOrder(order);
        orderTransaction.setAccount(order.getAccount());
        orderTransaction.setAmount(order.getCheckoutPrice());
        orderTransaction.setPaymentMethod(Transaction.PaymentMethod.INTERNAL_WALLET);
        orderTransaction.setType(Transaction.Type.ORDER);
        orderTransaction.setStatus(Transaction.Status.SUCCESS);
        orderTransaction = transactionService.create(orderTransaction);
        order.setTransaction(orderTransaction);

        // Use the voucher
        if (order.getVoucher() != null) {
            order.getVoucher()
                 .setState(Voucher.State.USED);
            order.getVoucher()
                 .setOrder(order);
            order.setVoucher(voucherService.update(order.getVoucher()));
        }

        // Use the slot
        for (OrderDetail orderDetail : order.getOrderDetails()) {
            if (orderDetail.getSlot() == null) continue;
            orderDetail.getSlot()
                       .setState(Slot.State.OPENED);
            orderDetail.setSlot(slotService.update(orderDetail.getSlot()));

            // Deduct Sku stock
            StockKeepingUnit sku = orderDetail.getStockKeepingUnit();
            sku.setStock(sku.getStock() - orderDetail.getQuantity());
            stockKeepingUnitService.update(sku);
        }

        log.info("Order {} paid by internal wallet successfully!",
                order.getOrderId());
        PlaceOrderResult result = new PlaceOrderResult();
        result.setOrder(order);
        return result;
    }

    private PlaceOrderResult payOrderByExternalWallet(Order order,
                                                      Transaction.PaymentMethod paymentMethod
    ) {
        // Create DEPOSIT transaction
        Transaction depositTransaction = new Transaction();
        depositTransaction.setAccount(order.getAccount());
        depositTransaction.setAmount(order.getCheckoutPrice());
        depositTransaction.setPaymentMethod(paymentMethod);
        depositTransaction.setType(Transaction.Type.DEPOSIT);
        depositTransaction.setOldBalance(order.getAccount()
                                              .getBalance());
        depositTransaction.setStatus(Transaction.Status.PENDING);
        depositTransaction = transactionService.create(depositTransaction);

        // Create ORDER transaction
        Transaction orderTransaction = new Transaction();
        orderTransaction.setOrder(order);
        orderTransaction.setOldBalance(order.getAccount()
                                            .getBalance());
        orderTransaction.setAccount(order.getAccount());
        orderTransaction.setAmount(order.getCheckoutPrice());
        orderTransaction.setPaymentMethod(Transaction.PaymentMethod.INTERNAL_WALLET);
        orderTransaction.setType(Transaction.Type.ORDER);
        orderTransaction.setStatus(Transaction.Status.PENDING);
        orderTransaction = transactionService.create(orderTransaction);
        order.setTransaction(orderTransaction);

        // Reserve the voucher
        if (order.getVoucher() != null) {
            order.getVoucher()
                 .setState(Voucher.State.RESERVED);
            order.getVoucher()
                 .setOrder(order);
            order.setVoucher(voucherService.update(order.getVoucher()));
        }

        // Reserve the slot
        for (OrderDetail orderDetail : order.getOrderDetails()) {
            if (orderDetail.getSlot() != null) {
                orderDetail.getSlot()
                        .setState(Slot.State.RESERVED);
                orderDetail.setSlot(slotService.update(orderDetail.getSlot()));
            }

            // Deduct Sku stock
            StockKeepingUnit sku = orderDetail.getStockKeepingUnit();
            sku.setStock(sku.getStock() - orderDetail.getQuantity());
            stockKeepingUnitService.update(sku);
        }

        // Generate pay URL
        String payUrl = paymentService.generatePaymentLinkForOrder(
                paymentMethod,
                order.getCheckoutPrice(),
                depositTransaction.getTransactionId(),
                order.getOrderId()
        );

        log.info("Order {} paid by external wallet; depositTxn = {}, orderTxn = {}",
                order.getOrderId(),
                depositTransaction.getTransactionId(),
                orderTransaction.getTransactionId());
        log.info("Payment URL {}",
                payUrl);
        PlaceOrderResult result = new PlaceOrderResult();
        result.setOrder(order);
        result.setPaymentRedirectUrl(payUrl);
        return result;
    }

    @Override
    @Transactional
    public synchronized void handlePaymentCallback(Transaction.PaymentMethod method,
                                                   long depositTxnId,
                                                   long orderId,
                                                   boolean success
    ) {
        // Update DEPOSIT transaction
        Transaction depositTransaction = transactionService.findById(depositTxnId);
        if (depositTransaction == null) {
            throw new IllegalArgumentException("Transaction " + depositTxnId + " not found");
        }
        if (depositTransaction.getStatus() != Transaction.Status.PENDING) {
            throw new IllegalStateException("Transaction " + depositTxnId + " is not pending");
        }
        if (depositTransaction.getType() != Transaction.Type.DEPOSIT) {
            throw new IllegalStateException("Transaction " + depositTxnId + " type is not DEPOSIT");
        }
        if (depositTransaction.getPaymentMethod() != method) {
            throw new IllegalStateException("Transaction " + depositTxnId + " method is not " + method.name());
        }

        Account account = depositTransaction.getAccount();
        account.setUpdateBalanceAt(LocalDateTime.now());
        account = accountService.update(account);
        depositTransaction.setAccount(account);

        BigDecimal oldBalance = account.getBalance();
        BigDecimal newBalance = success ? oldBalance.add(depositTransaction.getAmount()) : oldBalance;

        depositTransaction.setOldBalance(oldBalance);
        depositTransaction.setNewBalance(newBalance);
        depositTransaction.setStatus(success ? Transaction.Status.SUCCESS : Transaction.Status.FAILED);
        transactionService.update(depositTransaction);

        // Update ORDER transaction
        Order order = findById(orderId);
        if (order == null) {
            throw new IllegalArgumentException("Order " + orderId + " not found");
        }
        Transaction orderTransaction = order.getTransaction();
        if (orderTransaction == null) {
            throw new IllegalStateException("Order " + orderId + " transaction not found");
        }
        if (orderTransaction.getStatus() != Transaction.Status.PENDING) {
            throw new IllegalStateException("Transaction " + orderTransaction.getTransactionId() + " is not pending");
        }
        orderTransaction.setStatus(success ? Transaction.Status.SUCCESS : Transaction.Status.FAILED);
        orderTransaction.setOldBalance(newBalance);
        orderTransaction.setNewBalance(oldBalance);
        orderTransaction = transactionService.update(order.getTransaction());
        order.setTransaction(orderTransaction);

        // Update voucher
        if (order.getVoucher() != null) {
            Voucher voucher = order.getVoucher();
            voucher.setState(success ? Voucher.State.USED : Voucher.State.AVAILABLE);
            voucher.setOrder(success ? order : null);
            voucher = voucherService.update(voucher);
            order.setVoucher(voucher);
        }

        // Update slot
        for (OrderDetail orderDetail : order.getOrderDetails()) {
            Slot slot = orderDetail.getSlot();
            if (slot != null) {
                slot.setState(success ? Slot.State.OPENED : Slot.State.AVAILABLE);
                slot = slotService.update(slot);
                orderDetail.setSlot(slot);
            }

            if (!success) {
                // Recover Sku stock
                StockKeepingUnit sku = orderDetail.getStockKeepingUnit();
                sku.setStock(sku.getStock() + orderDetail.getQuantity());
                stockKeepingUnitService.update(sku);
            }
        }

        log.info("Order {} paid by external wallet status {}; depositTxn = {}, orderTxn = {}",
                orderId,
                orderTransaction.getStatus(),
                depositTxnId,
                orderTransaction.getTransactionId());
    }

    @Override
    public Order findById(long id) {
        return orderRepos.findById(id)
                         .orElse(null);
    }

    @Override
    public Order update(Order order) {
        Order existing = orderRepos.findById(order.getOrderId())
                                   .orElseThrow(() -> new IllegalArgumentException("Order does not exist"));
        EntityUtil.merge(existing,
                order);
        return orderRepos.save(existing);
    }

    @Override
    public Page<Order> getAll(ListParams params) {
        var spec = params.<Order>toSpec();
        return orderRepos.findAll(spec,
                params.getPageable());
    }


}