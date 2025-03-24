package com.fptgang.backend.config;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.math.BigDecimal;
import java.time.Duration;

@Configuration
@Getter
public class BlindBoxConfig {

    @Value("${voucher.default.discountRate:0.1}")
    private BigDecimal defaultDiscountRate;

    @Value("${voucher.default.limitAmount:100}")
    private BigDecimal defaultLimitAmount;

    @Value("${voucher.default.expiredMonths:1}")
    private int defaultExpiredMonths;

    @Value("${voucher.default.codeLength:10}")
    private int defaultCodeLength;

    // JWT and token configuration
    @Value("${jwt.expiry.minutes:15}")
    private int jwtExpiryMinutes;

    @Value("${jwt.refresh.expiry.days:7}")
    private int refreshTokenExpiryDays;

    @Value("${password.reset.expiry.minutes:15}")
    private int passwordResetExpiryMinutes;

    // Date format patterns
    @Value("${date.format.vnpay:yyyyMMddHHmmss}")
    private String vnpayDateFormat;

    // Currency configuration
    @Value("${currency.exchange.cache.key:CurrencyExchangeRate}")
    private String currencyExchangeCacheKey;

    @Value("${currency.exchange.default.rate:25000}")
    private BigDecimal defaultExchangeRate;

    @Value("${currency.exchange.cache.ttl.days:1}")
    private int currencyExchangeCacheTtlDays;

    // VNPAY configuration
    @Value("${vnpay.order.type:250000}")
    private String vnpayOrderType;

    @Value("${vnpay.locale:vn}")
    private String vnpayLocale;

    @Value("${vnpay.expire.minutes:15}")
    private int vnpayExpireMinutes;

    // Email templates
    @Value("${email.video.title:🚀 Your Exclusive Unboxing Video is Now Live!}")
    private String videoEmailTitle;

    @Value("${email.video.template:<h1>🎥 Your Video is Ready!</h1><p>Dear %s,</p><p>We are excited to inform you that your unboxing video has been successfully uploaded!</p><p>Click the link below to watch your video:</p>%s<br><p>Thank you for being with us!</p><p>Best regards,</p><p><strong>Your Company Team</strong></p>}")
    private String videoEmailTemplate;

    @Value("${email.password.reset.title:Password Reset Request}")
    private String passwordResetEmailTitle;

    @Value("${email.password.reset.template:Hello %s,\n\nYou have requested to reset your password. Please click the link below to reset it:\n%s\n\nThis link will expire in %d minutes.\n\nIf you didn't request this, please ignore this email.\n\nBest regards,\nYour Application Team}")
    private String passwordResetEmailTemplate;

    public Duration getJwtExpiryDuration() {
        return Duration.ofMinutes(jwtExpiryMinutes);
    }

    public Duration getRefreshTokenExpiryDuration() {
        return Duration.ofDays(refreshTokenExpiryDays);
    }

    public Duration getCurrencyExchangeCacheTtl() {
        return Duration.ofDays(currencyExchangeCacheTtlDays);
    }
}
