package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.BlindBoxCampaignId;
import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.service.PromotionalCampaignService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
public class PromotionalCampaignServiceImpl implements PromotionalCampaignService {

    private final PromotionalCampaignRepos promotionalCampaignRepos;

    @Autowired
    public PromotionalCampaignServiceImpl(PromotionalCampaignRepos promotionalCampaignRepos) {
        this.promotionalCampaignRepos = promotionalCampaignRepos;
    }

    @Override
    public PromotionalCampaign create(PromotionalCampaign promotionalCampaign) {
        promotionalCampaign.setCampaignId(null);
        if (promotionalCampaign.getDiscountRate().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Discount rate must be non-negative");
        }
        if (promotionalCampaign.getDiscountRate().compareTo(BigDecimal.ONE) > 0) {
            throw new IllegalArgumentException("Discount rate must be less than 1");
        }
        if(promotionalCampaign.getStartDate().isBefore(LocalDateTime.now())){
            throw new IllegalArgumentException("Start date must be in the future");
        }
        if(promotionalCampaign.getStartDate().isAfter(promotionalCampaign.getEndDate())){
            throw new IllegalArgumentException("Start date must be before end date");
        }
        return promotionalCampaignRepos.save(promotionalCampaign);
    }

    @Override
    public PromotionalCampaign findById(long id) {
        return promotionalCampaignRepos.findById(id).orElse(null);
    }

    @Override
    public PromotionalCampaign findBestOngoingCampaignForBlindBox(long blindBoxId) {
        return promotionalCampaignRepos.findBestOngoingCampaignForBlindBox(blindBoxId, LocalDateTime.now());
    }

    @Override
    public PromotionalCampaign findBestOngoingCampaignForSku(long skuId) {
        return promotionalCampaignRepos.findBestOngoingCampaignForSku(skuId, LocalDateTime.now());
    }

    @Override
    public PromotionalCampaign update(PromotionalCampaign campaign) {
        PromotionalCampaign existing = promotionalCampaignRepos.findById(campaign.getCampaignId())
                .orElseThrow(() -> new IllegalArgumentException("PromotionalCampaign does not exist"));
        if (campaign.getDiscountRate().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Discount rate must be non-negative");
        }
        if (campaign.getDiscountRate().compareTo(BigDecimal.ONE) > 0) {
            throw new IllegalArgumentException("Discount rate must be less than 1");
        }
        if(campaign.getStartDate() != null &&
                campaign.getStartDate().isBefore(existing.getStartDate())){
            throw new IllegalArgumentException("Cannot shrink start date");
        }
        if(campaign.getStartDate() != null &&
                campaign.getStartDate().isAfter(campaign.getEndDate())){
            throw new IllegalArgumentException("Start date must be before end date");
        }
        if (campaign.getBlindBoxCampaigns() != null) {
            log.info("Updating blind box campaigns {}", campaign.getBlindBoxCampaigns().size());
            existing.getBlindBoxCampaigns().forEach(blindBoxCampaign ->
            {
                if (campaign.getBlindBoxCampaigns().stream().noneMatch(b -> Objects.equals(b.getBlindBox().getBlindBoxId(), blindBoxCampaign.getBlindBox().getBlindBoxId()))) {
//                    blindBoxCampaign.setIsVisible(false);
                    log.info("Deleted blind box campaign {}", blindBoxCampaign.getBlindBox().getBlindBoxId());
                }
            });
            campaign.getBlindBoxCampaigns().forEach(blindBoxCampaign ->
            {
                if (existing.getBlindBoxCampaigns().stream().noneMatch(b -> Objects.equals(b.getBlindBox().getBlindBoxId(), blindBoxCampaign.getBlindBox().getBlindBoxId()))) {
                    blindBoxCampaign.setId(
                            new BlindBoxCampaignId( blindBoxCampaign.getBlindBox().getBlindBoxId(),campaign.getCampaignId())
                    );
                    blindBoxCampaign.setPromotionalCampaign(existing);
                    existing.getBlindBoxCampaigns().add(blindBoxCampaign);
                    log.info("Added blind box campaign {}", blindBoxCampaign.getBlindBox().getBlindBoxId());
                }
            });
            log.info("Updated blind box campaigns {}", existing.getBlindBoxCampaigns().size());
        }
        EntityUtil.merge(existing, campaign);
        return promotionalCampaignRepos.save(existing);
    }

    @Override
    public PromotionalCampaign deleteById(long id) {
        PromotionalCampaign promotionalCampaign = promotionalCampaignRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("PromotionalCampaign does not exist"));
        promotionalCampaign.setIsVisible(false);
        return promotionalCampaignRepos.save(promotionalCampaign);
    }

    @Override
    public Page<PromotionalCampaign> getAll(ListParams params, LocalDateTime fromDate, LocalDateTime toDate) {
        var spec = params.<PromotionalCampaign>toSpec();
        if (fromDate != null || toDate != null) {
            spec = spec.and(overlapsWith(fromDate, toDate));
        }
        return promotionalCampaignRepos.findAll(spec, params.getPageable());
    }

    private static Specification<PromotionalCampaign> overlapsWith(LocalDateTime fromDate, LocalDateTime toDate) {
        return (Root<PromotionalCampaign> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (fromDate != null) {
                predicates.add(cb.lessThanOrEqualTo(cb.literal(fromDate), root.get("endDate")));
            }

            if (toDate != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("startDate"), cb.literal(toDate)));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}