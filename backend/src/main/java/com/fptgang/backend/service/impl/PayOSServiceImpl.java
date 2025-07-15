package com.fptgang.backend.service.impl;

import com.fptgang.backend.config.PayOSConfig;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.service.OrderService;
import com.fptgang.backend.service.PaymentService;
import com.fptgang.backend.service.PayOSService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import vn.payos.PayOS;
import vn.payos.type.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class PayOSServiceImpl implements PayOSService {
    private final PayOS payOS;
    private final PayOSConfig payOSConfig;

    @Override
    public String createPayOSPayment(String orderInfo, BigDecimal amount, String orderCode, String returnUrl,
            String cancelUrl) {
        try {
            // Create item data
            ItemData item = ItemData.builder()
                    .name(orderInfo)
                    .quantity(1)
                    .price(amount.intValue())
                    .build();

            // Create checkout request data
            PaymentData paymentData = PaymentData.builder()
                    .orderCode(Long.valueOf(orderCode))
                    .amount(amount.intValue())
                    .description(orderInfo.substring(0, Math.min(25, orderInfo.length())))
                    .items(List.of(item))
                    .returnUrl(returnUrl != null ? returnUrl : payOSConfig.getReturnUrl())
                    .cancelUrl(cancelUrl != null ? cancelUrl : payOSConfig.getCancelUrl())
//                    .expiredAt(
//                            (int) (Instant.now().getEpochSecond()) + payOSConfig.getPaymentLinkExpirationSeconds())
                    .build();

            log.info("expiredAt: {}", paymentData.getExpiredAt());

            // Create payment link
            CheckoutResponseData checkoutResponseData = payOS.createPaymentLink(paymentData);

            log.info("PayOS payment link created successfully for order code: {}", orderCode);
            return checkoutResponseData.getCheckoutUrl();
        } catch (Exception e) {
            log.error("Failed to create PayOS payment link for order code: {}", orderCode, e);
            throw new RuntimeException("Failed to create PayOS payment link: " + e.getMessage(), e);
        }
    }
}