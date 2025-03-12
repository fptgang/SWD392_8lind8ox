package com.fptgang.backend.service;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.model.OrderStatusHistory;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.model.checkout.Cart;
import com.fptgang.backend.model.checkout.PlaceOrderResult;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface OrderService {
    PlaceOrderResult place(Cart cart);
    void handlePaymentCallback(Transaction.PaymentMethod method, long depositTxnId, long orderId, boolean success);
    Order cancel(Order order, OrderStatusHistory.State reason);
    Order findById(long id);
    Order update(Order order);
    Page<Order> getAll(ListParams params);
}