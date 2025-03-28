package com.fptgang.backend.service.impl;

import com.fptgang.backend.config.BlindBoxConfig;
import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.RefreshToken;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.RefreshTokenRepos;
import com.fptgang.backend.service.RefreshTokenService;
import com.fptgang.backend.util.Fingerprint;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import org.jetbrains.annotations.Nullable;
import java.time.Duration;
import java.time.Instant;
import java.util.UUID;

@Service
public class RefreshTokenServiceImpl implements RefreshTokenService {
    private static final Logger LOGGER = LoggerFactory.getLogger(RefreshTokenServiceImpl.class);

    private final RefreshTokenRepos refreshTokenRepos;
    private final AccountRepos accountRepos;
    private final BlindBoxConfig blindBoxConfig;

    public RefreshTokenServiceImpl(RefreshTokenRepos refreshTokenRepos,
            AccountRepos accountRepos,
            BlindBoxConfig blindBoxConfig) {
        this.refreshTokenRepos = refreshTokenRepos;
        this.accountRepos = accountRepos;
        this.blindBoxConfig = blindBoxConfig;
    }

    @Override
    public RefreshToken createRefreshToken(String email, Fingerprint fingerprint) {
        Account account = accountRepos.findByEmail(email)
                .orElseThrow(() -> new InvalidInputException("Account not found with email " + email));

        RefreshToken refreshToken = RefreshToken.builder()
                .token(UUID.randomUUID().toString())
                .ipAddress(fingerprint.getIpAddress())
                .sessionId(fingerprint.getSessionId())
                .clientInfo(fingerprint.getClientInfo())
                .expiryDate(Instant.now().plus(blindBoxConfig.getRefreshTokenExpiryDuration()))
                .account(account)
                .build();

        LOGGER.info(
                "A new refresh token {} is created associating with user {}, sessionId {}, ip {}, client {}",
                refreshToken.getToken(), email, fingerprint.getSessionId(), fingerprint.getIpAddress(),
                fingerprint.getClientInfo());

        return refreshTokenRepos.save(refreshToken);
    }

    @Nullable
    @Override
    public RefreshToken findByToken(String token) {
        return refreshTokenRepos.findByToken(token);
    }

    @Override
    public Page<RefreshToken> getAllByAccountId(Long accountId, Pageable pageable) {
        return refreshTokenRepos.findAllByAccount_AccountId(accountId, pageable);
    }

    @Override
    @Transactional
    public void revokeRefreshTokenByAccountEmail(String email) {
        refreshTokenRepos.deleteAllByAccount_Email(email);
        LOGGER.info("Revoked all refresh tokens associating with email {}", email);
    }

    @Override
    @Transactional
    public void revokeRefreshTokenBySessionId(String sessionId) {
        refreshTokenRepos.deleteAllBySessionId(sessionId);
        LOGGER.info("Revoked all refresh tokens associating with sessionId {}", sessionId);
    }
}
