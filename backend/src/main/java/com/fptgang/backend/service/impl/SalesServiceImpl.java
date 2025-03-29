package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.BlindBox;
import com.fptgang.backend.model.BlindBoxCampaign;
import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.model.sales.TrendingProduct;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.SalesRepos;
import com.fptgang.backend.service.SalesService;
import com.fptgang.backend.service.params.ListParams;
import com.google.common.base.Preconditions;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class SalesServiceImpl implements SalesService {
    private final BlindBoxRepos blindBoxRepos;
    private final SalesRepos salesRepos;
    private final RedisTemplate<String, Object> redisTemplate;
    private static final Duration CACHE_TTL = Duration.ofMinutes(5);

    public SalesServiceImpl(BlindBoxRepos blindBoxRepos, SalesRepos salesRepos, RedisTemplate<String, Object> redisTemplate) {
        this.blindBoxRepos = blindBoxRepos;
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

    @Override
    public Page<BlindBox> getAllHotSales(ListParams params) {
        var now = LocalDateTime.now();

        Specification<BlindBox> spec = (root, query, cb) -> {
            Join<BlindBox, BlindBoxCampaign> blindBoxCampaignJoin = root.join("blindBoxCampaigns");
            Join<BlindBoxCampaign, PromotionalCampaign> promoCampaignJoin = blindBoxCampaignJoin.join("promotionalCampaign");

            Predicate isVisible = cb.isTrue(promoCampaignJoin.get("isVisible"));
            Predicate startDateCondition = cb.lessThanOrEqualTo(promoCampaignJoin.get("startDate"), now);
            Predicate endDateCondition = cb.greaterThanOrEqualTo(promoCampaignJoin.get("endDate"), now);

            return cb.exists(query.subquery(BlindBoxCampaign.class)
                    .select(blindBoxCampaignJoin)
                    .where(cb.and(isVisible, startDateCondition, endDateCondition)));
        };

        return blindBoxRepos.findAll(spec, params.getPageable());
    }
}
