package com.fptgang.backend.service;

import com.fptgang.backend.model.Account;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface AccountService {
    Account create(Account account);
    Account findById(long id);
    Account findByEmail(String email);
    Account update(Account account);
    Account deleteById(long id);
    Page<Account> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Account> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Account> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}
