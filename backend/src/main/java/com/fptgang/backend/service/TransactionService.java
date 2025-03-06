package com.fptgang.backend.service;

import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface TransactionService {
    String create(Transaction transaction);
    Transaction findById(long id);
    Transaction update(Transaction transaction);
    Transaction deleteById(long id);
    Page<Transaction> getAll(ListParams params);
}