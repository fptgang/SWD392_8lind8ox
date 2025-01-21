package com.fptgang.backend.controller;
import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.TransactionsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.AccountMapper;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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
    public ResponseEntity<GetTransactions200Response> getTransactions(GetAccountsPageableParameter pageable, String filter) {
        return TransactionsApi.super.getTransactions(pageable, filter);
    }

    @Override
    public ResponseEntity<TransactionDto> updateTransaction(Integer transactionId, TransactionDto transactionDto) {
        return TransactionsApi.super.updateTransaction(transactionId, transactionDto);
    }
}
