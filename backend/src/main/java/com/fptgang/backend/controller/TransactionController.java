package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.TransactionsApi;
import com.fptgang.backend.api.model.GetTransactions200Response;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.api.model.TransactionDto;
import com.fptgang.backend.config.VnPayConfig;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.TransactionMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.service.TransactionService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class TransactionController implements TransactionsApi {
    private final TransactionService transactionService;
    private final TransactionMapper transactionMapper;

    public TransactionController(TransactionService transactionService, TransactionMapper transactionMapper) {
        this.transactionService = transactionService;
        this.transactionMapper = transactionMapper;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return TransactionsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<String> createTransaction(TransactionDto transactionDto) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admin can create transactions");
        }
        String response = transactionService.create(transactionMapper.toEntity(transactionDto), SecurityUtil.getRemoteAddress());
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<TransactionDto> getTransactionById(Long transactionId) {
        log.info("Getting transaction by id {}", transactionId);
        Transaction transaction = transactionService.findById(transactionId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            String currentEmail = SecurityUtil.requireCurrentUserEmail();
            if (!transaction.getAccount().getEmail().equalsIgnoreCase(currentEmail)) {
                throw new AccessDeniedException("You are not allowed to view this transaction");
            }
        }
        return new ResponseEntity<>(
                transactionMapper.toDTO(
                        transactionService.findById(transactionId),
                        DetailLevel.FULL
                ),
                HttpStatus.OK
        );
    }

    @Override
    public ResponseEntity<GetTransactions200Response> getTransactions(Pageable pageable, String filter, String search) {
        log.info("Fetching transactions");

        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter)
                .includeInvisible(includeInvisible);

        // Staffs and Customers can only view their own transactions
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            params.setFilter("account.accountId", "eq", SecurityUtil.getCurrentUserId());
        }

        var resultPage = transactionService.getAll(params.build())
                .map(t -> transactionMapper.toDTO(t, DetailLevel.SUMMARY));

        return OpenApiHelper.respondPage(resultPage, GetTransactions200Response.class);
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
