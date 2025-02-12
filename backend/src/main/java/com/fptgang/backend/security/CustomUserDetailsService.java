package com.fptgang.backend.security;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.repository.AccountRepos;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    private static final Logger LOGGER = LoggerFactory.getLogger(CustomUserDetailsService.class);
    private final AccountRepos accountRepos;

    public CustomUserDetailsService(AccountRepos accountRepos) {
        this.accountRepos = accountRepos;
    }

    @Override
    @Deprecated // AVOID using because it fetches from database
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Account account = accountRepos.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        return createUserDetails(account.getAccountId(), account.getEmail(), account.getRole());
    }

    public UserDetails createUserDetails(long accountId, String email, Account.Role role) {
        LOGGER.debug("New UserDetails for id={}, email={}", accountId, email);
        return new AppUser(
                accountId,
                email,
                null, // never store password
                List.of(new SimpleGrantedAuthority(role.toString()))
        );
    }
}
