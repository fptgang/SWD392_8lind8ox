package com.fptgang.backend.service;

import com.fptgang.backend.model.Account;
import jakarta.validation.constraints.NotNull;
import org.springframework.security.oauth2.jwt.Jwt;

import javax.annotation.Nullable;

public interface JwtService {
    @NotNull
    Jwt generateJwt(long accountId, String email, Account.Role role);

    String createJwtFromRefreshToken(String token);

    @NotNull
    String generateToken(long accountId, String email, Account.Role role);

    @Nullable
    Jwt parseToken(String token);
}
