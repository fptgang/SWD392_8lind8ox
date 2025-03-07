package com.fptgang.backend.controller;


import com.fptgang.backend.config.VnPayConfig;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.service.TransactionService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;


@Slf4j
@RestController
@RequestMapping("/api/v1/vnpay")
public class VNPAYController
{
    private final TransactionService transactionService;
    public VNPAYController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }
    @GetMapping("/vnpay_ipn")
    public int handleVNPayReturn(@RequestParam Map<String, String> requestParams) throws UnsupportedEncodingException {
        Map fields = new HashMap();
        for (Map.Entry<String, String> entry : requestParams.entrySet()) {
            fields.put(URLEncoder.encode(entry.getKey(), StandardCharsets.US_ASCII.toString()), URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII.toString()));
        }
        String paymentId = requestParams.get("vnp_TxnRef");
        String vnp_SecureHash = requestParams.get("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }
        log.info("vnp_TxnRef: " + paymentId, "vnp_SecureHash: " + vnp_SecureHash);
        Transaction transaction = transactionService.findById(Long.parseLong(paymentId));
        if (transaction == null) {
            log.info("Transaction not found");
            return -1;
        }
        if (VnPayConfig.hashAllFields(fields).equals(vnp_SecureHash)) {
            if ("00".equals(fields.get("vnp_ResponseCode"))) {
                log.info("Payment success");
                transaction.setStatus(Transaction.Status.SUCCESS);
                transactionService.update(transaction);
                return 1;
            } else {
                log.info("Payment failed");
                transaction.setStatus(Transaction.Status.FAILED);
                transactionService.update(transaction);
                return 0;
            }
        }
        log.info("FAILED: Invalid signature");
        return -1;
    }
}
