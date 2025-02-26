package com.fptgang.backend.service;

import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface TransactionService {
    String createVNPay(Transaction transaction,String vnp_IpAddr);
    String create(Transaction transaction,String vnp_IpAddr);
    Transaction findById(long id);
    Transaction update(Transaction transaction);
    Transaction deleteById(long id);
    Page<Transaction> getAll(ListParams params);
}