package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.TransactionsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.TransactionMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.TransactionService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

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
    public ResponseEntity<TransactionDto> createTransaction(TransactionDto transactionDto) {
        log.info("Creating transaction");
        ResponseEntity<TransactionDto> response = new ResponseEntity<>(transactionMapper
                .toDTO(transactionService.create(transactionMapper.toEntity(transactionDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<TransactionDto> getTransactionById(Long transactionId) {
        log.info("Getting transaction by id " + transactionId);
        return new ResponseEntity<>(transactionMapper.toDTO(transactionService.findById(transactionId)), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetTransactions200Response> getTransactions(Pageable pageable, String filter, String search) {
        log.info("Getting transactions");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var res = transactionService.getAll(page, filter, includeInvisible).map(transactionMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetTransactions200Response.class);
    }
}
