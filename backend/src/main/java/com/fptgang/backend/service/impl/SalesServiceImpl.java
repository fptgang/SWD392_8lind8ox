package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.sales.TrendingProduct;
import com.fptgang.backend.repository.SalesRepos;
import com.fptgang.backend.service.SalesService;
import com.google.common.base.Preconditions;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.List;

@Service
public class SalesServiceImpl implements SalesService {
    private final SalesRepos salesRepos;
    private final RedisTemplate<String, Object> redisTemplate;
    private static final Duration CACHE_TTL = Duration.ofMinutes(5);

    public SalesServiceImpl(SalesRepos salesRepos, RedisTemplate<String, Object> redisTemplate) {
        this.salesRepos = salesRepos;
        this.redisTemplate = redisTemplate;
    }

    @Override
    public List<TrendingProduct> getTrendingProducts(int interval) {
        Preconditions.checkArgument(interval > 0);

        String cacheKey = "trending_products:" + interval;

        List<TrendingProduct> cachedResult = (List<TrendingProduct>) redisTemplate.opsForValue().get(cacheKey);
        if (cachedResult != null) {
            return cachedResult;
        }

        List<TrendingProduct> result = salesRepos.findBlindBoxSales(interval);

        redisTemplate.opsForValue().set(
                cacheKey,
                result,
                CACHE_TTL
        );

        return result;
    }
}
