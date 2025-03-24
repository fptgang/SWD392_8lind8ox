package com.fptgang.backend.service.impl;

import com.fptgang.backend.config.BlindBoxConfig;
import com.fptgang.backend.service.PasswordResetTokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Optional;
import java.util.UUID;

@Service
public class PasswordResetTokenServiceImpl implements PasswordResetTokenService {
    private final RedisTemplate<String, String> redisTemplate;
    private final BlindBoxConfig blindBoxConfig;

    @Autowired
    public PasswordResetTokenServiceImpl(RedisTemplate<String, String> redisTemplate, BlindBoxConfig blindBoxConfig) {
        this.redisTemplate = redisTemplate;
        this.blindBoxConfig = blindBoxConfig;
    }

    public String generateToken(String email) {
        String token = UUID.randomUUID().toString();
        redisTemplate.opsForValue().set(
                "password_reset:" + token,
                email,
                Duration.ofMinutes(blindBoxConfig.getPasswordResetExpiryMinutes()));
        return token;
    }

    public Optional<String> getEmailFromToken(String token) {
        String email = redisTemplate.opsForValue().get("password_reset:" + token);
        return Optional.ofNullable(email);
    }

    public void invalidateToken(String token) {
        redisTemplate.delete("password_reset:" + token);
    }
}
