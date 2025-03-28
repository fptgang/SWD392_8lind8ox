package com.fptgang.backend.service.impl;

import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.security.AuthContext;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
public class AccountServiceImpl implements AccountService {
    private final AccountRepos accountRepos;
    private final AuthContext authContext;

    @Autowired
    public AccountServiceImpl(AccountRepos accountRepos, AuthContext authContext) {
        this.accountRepos = accountRepos;
        this.authContext = authContext;
    }

    @Override
    public Account create(Account account) {
        if (accountRepos.findByEmail(account.getEmail()).isPresent()) {
            throw new InvalidInputException("Email already exists");
        }
        account.setIsVisible(true); // Override isVisible
        return accountRepos.save(account);
    }

    @Override
    public Account findById(long id) {
        var account = accountRepos.findById(id).orElse(null);

        // Only ADMIN and STAFF can access invisible entity
        if (account != null && !account.getIsVisible()) {
            authContext.assertPermission(Account.Role.STAFF);
        }

        return account;
    }

    @Override
    public Account findByEmail(String email) {
        var account = accountRepos.findByEmail(email).orElse(null);

        // Only ADMIN and STAFF can access invisible entity
        if (account != null && !account.getIsVisible()) {
            authContext.assertPermission(Account.Role.STAFF);
        }

        return account;
    }

    @Override
    public Account update(Account account) {
        Account existing = accountRepos.findById(account.getAccountId())
                .orElseThrow(() -> new InvalidInputException("Account does not exist"));

        // Only ADMIN and STAFF can access invisible entity
        if (!existing.getIsVisible()) {
            authContext.assertPermission(Account.Role.STAFF);
        }

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
        // Hide invisible entities if not ADMIN or STAFF
        if (!authContext.hasPermission(Account.Role.STAFF)) {
            params.setIncludeInvisible(false);
        }

        var spec = params.<Account>toSpec();
        return accountRepos.findAll(spec, params.getPageable());
    }
}
