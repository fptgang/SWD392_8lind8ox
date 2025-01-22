package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.repository.TransactionRepos;
import com.fptgang.backend.service.TransactionService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class TransactionServiceImpl implements TransactionService {

    private final TransactionRepos transactionRepos;

    @Autowired
    public TransactionServiceImpl(TransactionRepos transactionRepos) {
        this.transactionRepos = transactionRepos;
    }

    @Override
    public Transaction create(Transaction transaction) {
        return transactionRepos.save(transaction);
    }

    @Override
    public Transaction findById(long id) {
        return transactionRepos.findById(id).orElse(null);
    }

    @Override
    public Transaction update(Transaction transaction) {
        if (transaction.getTransactionId() == null) {
            throw new IllegalArgumentException("Transaction does not exist");
        }
        return transactionRepos.save(transaction);
    }

    @Override
    public Transaction deleteById(long id) {
        Transaction transaction = transactionRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Transaction does not exist"));
        transaction.setVisible(false);
        return transactionRepos.save(transaction);
    }

    @Override
    public Page<Transaction> getAll(Pageable pageable, String filter, boolean includeInvisible) {
        var spec = OpenApiHelper.<Transaction>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(filter));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return transactionRepos.findAll(spec, pageable);
    }
}