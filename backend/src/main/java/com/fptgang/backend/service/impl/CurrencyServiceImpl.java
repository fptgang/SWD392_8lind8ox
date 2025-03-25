package com.fptgang.backend.service.impl;

import com.fptgang.backend.config.BlindBoxConfig;
import com.fptgang.backend.service.CurrencyService;
import com.fptgang.backend.util.CurrencyType;
import com.fptgang.backend.util.CurrencyUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.concurrent.TimeUnit;

@Service
public class CurrencyServiceImpl implements CurrencyService {
    private static final Logger logger = LoggerFactory.getLogger(CurrencyServiceImpl.class);
    private static final HttpClient httpClient = HttpClient.newHttpClient();
    private static final Gson gson = new Gson();

    @Value("${currencyapi.key}")
    private String apiKey;

    private final RedisTemplate<String, Object> redisTemplate;
    private final BlindBoxConfig blindBoxConfig;

    public CurrencyServiceImpl(RedisTemplate<String, Object> redisTemplate, BlindBoxConfig blindBoxConfig) {
        this.redisTemplate = redisTemplate;
        this.blindBoxConfig = blindBoxConfig;
    }

    @Override
    public BigDecimal convertUsdToVnd(BigDecimal usdAmount) {
        BigDecimal exchangeRate = fetchLatestExchangeRate(CurrencyType.VND);
        return CurrencyUtil.convertUsdToVnd(usdAmount, exchangeRate);
    }

    @Override
    public BigDecimal convert(BigDecimal amount, CurrencyType from, CurrencyType to) {
        if (from == to) {
            return amount;
        }

        BigDecimal exchangeRate = fetchLatestExchangeRate(to);
        return CurrencyUtil.convertUsdToVnd(amount, exchangeRate);
    }

    @Override
    public BigDecimal fetchLatestExchangeRate(CurrencyType to) {
        String cacheKey = blindBoxConfig.getCurrencyExchangeCacheKey() + ":" + to;

        // Check cache first
        Object cachedRate = redisTemplate.opsForValue().get(cacheKey);
        if (cachedRate != null) {
            return new BigDecimal(cachedRate.toString());
        }

        // Fetch from API
        try {
            String url = String.format("https://api.currencyapi.com/v3/latest?apikey=%s&currencies=%s",
                    apiKey, to);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            JsonObject jsonResponse = gson.fromJson(response.body(), JsonObject.class);

            if (jsonResponse.has("data") && jsonResponse.getAsJsonObject("data").has(to.toString())) {
                JsonObject data = jsonResponse.getAsJsonObject("data").getAsJsonObject(to.toString());
                BigDecimal exchangeRate = data.get("value").getAsBigDecimal();
                redisTemplate.opsForValue().set(
                        cacheKey,
                        exchangeRate,
                        blindBoxConfig.getCurrencyExchangeCacheTtl().toDays(),
                        TimeUnit.DAYS);
                return exchangeRate;
            }
        } catch (Exception e) {
            logger.error("Error fetching exchange rate for {} from CurrencyAPI", to, e);
        }
        return blindBoxConfig.getDefaultExchangeRate();
    }
}
