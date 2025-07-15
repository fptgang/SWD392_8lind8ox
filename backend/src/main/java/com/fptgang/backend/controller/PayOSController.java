package com.fptgang.backend.controller;

import com.fptgang.backend.service.PayOSService;
import com.fptgang.backend.service.PayOSWebhookService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import vn.payos.type.Webhook;

@RestController
@RequestMapping("/api/v1/payos")
@RequiredArgsConstructor
@Slf4j
public class PayOSController {
    private final PayOSWebhookService payOSWebhookService;

    @Operation(summary = "Handle PayOS webhook", description = "Endpoint to receive PayOS payment status updates")
    @PostMapping("/webhook")
    public ResponseEntity<String> handlePaymentWebhook(@RequestBody Webhook webhookData) {
        log.info("Received PayOS webhook for order code: {}", webhookData.getCode());

        try {
            String result = payOSWebhookService.handlePaymentWebhook(webhookData);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("Failed to process PayOS webhook: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body("Webhook processing failed: " + e.getMessage());
        }
    }

    @Operation(summary = "Confirm webhook URL with PayOS")
    @PostMapping("/webhook/confirm")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> confirmWebhook(
            @Parameter(description = "Webhook URL to confirm", name = "webhookUrl") @RequestParam(name = "webhookUrl") String webhookUrl) {

        log.info("Confirming PayOS webhook URL: {}", webhookUrl);

        try {
            String result = payOSWebhookService.confirmWebhook(webhookUrl);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("Failed to confirm PayOS webhook URL: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body("Webhook confirmation failed: " + e.getMessage());
        }
    }
}