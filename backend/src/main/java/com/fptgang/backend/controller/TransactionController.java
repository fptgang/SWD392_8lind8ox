package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.TransactionsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class TransactionController implements TransactionsApi {

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return TransactionsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<TransactionDto> createTransaction(TransactionDto transactionDto) {
        return TransactionsApi.super.createTransaction(transactionDto);
    }

    @Override
    public ResponseEntity<Void> deleteTransaction(Integer transactionId) {
        return TransactionsApi.super.deleteTransaction(transactionId);
    }

    @Override
    public ResponseEntity<TransactionDto> getTransactionById(Integer transactionId) {
        return TransactionsApi.super.getTransactionById(transactionId);
    }

    @Override
    public ResponseEntity<GetTransactions200Response> getTransactions(Pageable pageable, String filter, String search) {
        log.info("Getting transactions");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        return OpenApiHelper.respondPage(null, GetTransactions200Response.class);
    }

    @Override
    public ResponseEntity<TransactionDto> updateTransaction(Integer transactionId, TransactionDto transactionDto) {
        return TransactionsApi.super.updateTransaction(transactionId, transactionDto);
    }
}
