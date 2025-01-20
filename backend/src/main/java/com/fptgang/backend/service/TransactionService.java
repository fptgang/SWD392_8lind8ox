package com.fptgang.backend.service;

import com.fptgang.backend.model.Transaction;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface TransactionService {
    Transaction create(Transaction transaction);
    Transaction findById(long id);
    Transaction update(Transaction transaction);
    Transaction deleteById(long id);
    Page<Transaction> getAll(Pageable pageable, String filter, boolean includeInvisible);
    default Page<Transaction> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, false);
    }
}