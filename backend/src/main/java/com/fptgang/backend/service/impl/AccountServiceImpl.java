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
    private static final List<String> WHITELIST_PATHS =
            List.of(
                    "accountId",
                    "email",
                    "firstName",
                    "lastName",
                    "balance",
                    "role",
                    "isVerified",
                    "verifiedAt",
                    "createdAt",
                    "updatedAt"
            );

    private final AccountRepos accountRepos;
    private final PasswordEncoderConfig passwordEncoderConfig;

    @Autowired
    public AccountServiceImpl(AccountRepos accountRepos, PasswordEncoderConfig passwordEncoderConfig) {
        this.accountRepos = accountRepos;
        this.passwordEncoderConfig = passwordEncoderConfig;
        createTestAccount();
    }

    private void createTestAccount() {
        for (int i = 0; i < 4; i++) {
            if (accountRepos.findByEmail((i % 2 > 0 ? "admin" :"test") + (i/2+1) + "@example.com").isPresent()) {
                continue;
            }
            createTestAccount(i);
        }
    }

    private Account createTestAccount(Integer accountId) {
        Account account = new Account();
        account.setEmail((accountId % 2 > 0 ? "admin" :"test") + (accountId/2+1)  + "@example.com");
        account.setPassword(passwordEncoderConfig.bcryptEncoder().encode("12345")   );
        account.setVisible(true);
        account.setBalance(BigDecimal.valueOf(0));
        account.setVerified(false);
        account.setRole(accountId % 2 > 0 ? Role.ADMIN : Role.CLIENT);
        account.setFirstName("John");
        account.setLastName(accountId % 2 > 0 ? "Admin" : "Doe");
        return create(account);
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
    public Page<Account> getAll(Pageable pageable, String filter, boolean includeInvisible) {
        var spec = OpenApiHelper.<Account>toSpecification(filter, WHITELIST_PATHS);
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return accountRepos.findAll(spec, pageable);
    }
}
