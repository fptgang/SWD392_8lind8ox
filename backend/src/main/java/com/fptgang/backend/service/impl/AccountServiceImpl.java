package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.security.PasswordEncoderConfig;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class AccountServiceImpl implements AccountService {
    private final AccountRepos accountRepos;

    @Autowired
    public AccountServiceImpl(AccountRepos accountRepos) {
        this.accountRepos = accountRepos;
    }

    @Override
    public Account create(Account account) {
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
        if (account.getAccountId() == null) {
            throw new IllegalArgumentException("Account does not exist");
        }
        return accountRepos.save(account);
    }

    @Override
    public Account deleteById(long id) {
        Account account = accountRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Account does not exist"));
        account.setVisible(false);
        return accountRepos.save(account);
    }

    @Override
    public Page<Account> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Account>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return accountRepos.findAll(spec, pageable);
    }
}
