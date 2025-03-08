package com.fptgang.backend.service;

import com.fptgang.backend.model.Transaction;

import java.math.BigDecimal;

public interface PaymentService {
    String generatePaymentLinkForDeposit(Transaction.PaymentMethod method, BigDecimal amount, long transactionId);
    String generatePaymentLinkForOrder(Transaction.PaymentMethod method, BigDecimal amount, long transactionId, long orderId);
    void handleDepositCallback(Transaction.PaymentMethod method, long depositTxnId, boolean success);
}
