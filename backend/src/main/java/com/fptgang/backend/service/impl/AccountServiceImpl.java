package com.fptgang.backend.service.impl;

import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
public class AccountServiceImpl implements AccountService {
    private final AccountRepos accountRepos;

    @Autowired
    public AccountServiceImpl(AccountRepos accountRepos) {
        this.accountRepos = accountRepos;
    }

    @Override
    public Account create(Account account) {
        if (accountRepos.findByEmail(account.getEmail()).isPresent()) {
            throw new InvalidInputException("Email already exists");
        }
        return accountRepos.save(account);
    }

    @Override
    public Account findById(long id) {
        return accountRepos.findById(id).orElse(null);
    }

    @Override
    public Account findByEmail(String email) {
        return accountRepos.findByEmail(email).orElse(null);
    }

    @Override
    public Account update(Account account) {
        Account existing = accountRepos.findById(account.getAccountId())
                .orElseThrow(() -> new InvalidInputException("Account does not exist"));
        existing.setPassword(account.getPassword());
        EntityUtil.merge(existing, account);
        return accountRepos.save(existing);
    }

    @Override
    public Account deleteById(long id) {
        Account account = accountRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Account does not exist"));
        account.setIsVisible(false);
        return accountRepos.save(account);
    }

    @Override
    public Page<Account> getAll(ListParams params) {
        var spec = params.<Account>toSpec();
        return accountRepos.findAll(spec, params.getPageable());
    }
}
