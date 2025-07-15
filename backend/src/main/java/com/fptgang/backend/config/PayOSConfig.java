package com.fptgang.backend.config;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import vn.payos.PayOS;

@Configuration
@Data
public class PayOSConfig {
    @Value("${PAYOS_CLIENT_ID}")
    private String clientId;

    @Value("${PAYOS_API_KEY}")
    private String apiKey;

    @Value("${PAYOS_CHECKSUM_KEY}")
    private String checksumKey;

    @Value("${PAYOS_RETURN_URL}")
    private String returnUrl;

    @Value("${PAYOS_CANCEL_URL}")
    private String cancelUrl;

    @Value("${PAYOS_PAYMENT_LINK_EXPIRATION_SECONDS:900}")
    private Integer paymentLinkExpirationSeconds;

    @Bean
    public PayOS payOS() {
        return new PayOS(clientId, apiKey, checksumKey);
    }
}