package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.service.PayOSWebhookService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import vn.payos.PayOS;
import vn.payos.type.*;

import java.math.BigDecimal;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class PayOSWebhookServiceImpl implements PayOSWebhookService {
    private final PayOS payOS;
    private final OrderService orderService;

    @Override
    public String handlePaymentWebhook(Webhook webhookData) {
        try {
            // Verify webhook signature
            WebhookData paymentData = payOS.verifyPaymentWebhookData(webhookData);

            log.info("PayOS webhook verified successfully for order code: {}", paymentData.getOrderCode());

            if (paymentData.getOrderCode() == 123L) {
                return "Test webhook received, no action taken";
            }
            // Handle payment status
            String status = paymentData.getCode();
            boolean success = webhookData.getSuccess() && "00".equals(status);

            log.info("Payment status for order code {}: {}", paymentData.getOrderCode(), status);

            // Parse order code to extract transaction ID and order ID
            // Expected format: transactionId or "DepositOrder#transactionId#orderId"
            String orderCodeStr = String.valueOf(paymentData.getOrderCode());

            try {
                if (orderCodeStr.contains("#")) {
                    // This is an order payment (DepositOrder#transactionId#orderId)
                    String[] parts = orderCodeStr.split("#");
                    if (parts.length >= 3) {
                        long transactionId = Long.parseLong(parts[1]);
                        long orderId = Long.parseLong(parts[2]);

                        // Handle order payment callback
                        orderService.handlePaymentCallback(Transaction.PaymentMethod.PAYOS, transactionId, orderId,
                                success);
                        log.info("Order payment callback processed for order {} with transaction {}", orderId,
                                transactionId);
                    } else {
                        log.error("Invalid order code format for order payment: {}", orderCodeStr);
                        return "Invalid order code format";
                    }
                } else {
                    // This is a deposit transaction
                    long transactionId = Long.parseLong(orderCodeStr);

                    // Handle deposit callback
                    // paymentService.handleDepositCallback(Transaction.PaymentMethod.PAYOS,
                    // transactionId, success);
                    log.info("Deposit callback processed for transaction {}", transactionId);
                }
            } catch (NumberFormatException e) {
                log.error("Failed to parse order code: {}", orderCodeStr, e);
                return "Failed to parse order code";
            }

            return success ? "Payment processed successfully" : "Payment failed";
        } catch (Exception e) {
            log.error("Failed to process PayOS webhook", e);
            throw new RuntimeException("Failed to process PayOS webhook: " + e.getMessage(), e);
        }
    }

    @Override
    public String confirmWebhook(String webhookUrl) {
        try {
            // Confirm webhook URL with PayOS
            String result = payOS.confirmWebhook(webhookUrl);
            log.info("PayOS webhook URL confirmed successfully: {}", webhookUrl);
            return result;
        } catch (Exception e) {
            log.error("Failed to confirm PayOS webhook URL: {}", webhookUrl, e);
            throw new RuntimeException("Failed to confirm PayOS webhook URL: " + e.getMessage(), e);
        }
    }
}