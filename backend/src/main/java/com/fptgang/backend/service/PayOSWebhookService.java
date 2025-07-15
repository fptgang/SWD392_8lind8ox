package com.fptgang.backend.service;

import vn.payos.type.Webhook;

import java.math.BigDecimal;

public interface PayOSWebhookService {

    String handlePaymentWebhook(Webhook webhookData);

    String confirmWebhook(String webhookUrl);
}