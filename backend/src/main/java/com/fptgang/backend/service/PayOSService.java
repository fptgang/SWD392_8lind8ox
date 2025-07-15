package com.fptgang.backend.service;

import vn.payos.type.Webhook;

import java.math.BigDecimal;

public interface PayOSService {
    String createPayOSPayment(String orderInfo, BigDecimal amount, String orderCode, String returnUrl,
            String cancelUrl);
}