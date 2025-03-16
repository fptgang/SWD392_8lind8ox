package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.BlindBoxCampaignId;
import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.service.PromotionalCampaignService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
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
    public PromotionalCampaign update(PromotionalCampaign promotionalCampaign) {
        PromotionalCampaign existing = promotionalCampaignRepos.findById(promotionalCampaign.getCampaignId())
                .orElseThrow(() -> new IllegalArgumentException("PromotionalCampaign does not exist"));
        if(promotionalCampaign.getStartDate().isBefore(LocalDateTime.now())){
            throw new IllegalArgumentException("Start date must be in the future");
        }
        if(promotionalCampaign.getStartDate().isAfter(promotionalCampaign.getEndDate())){
            throw new IllegalArgumentException("Start date must be before end date");
        }
        if (promotionalCampaign.getBlindBoxCampaigns() != null) {
            log.info("Updating blind box campaigns {}", promotionalCampaign.getBlindBoxCampaigns().size());
            existing.getBlindBoxCampaigns().forEach(blindBoxCampaign ->
            {
                if (promotionalCampaign.getBlindBoxCampaigns().stream().noneMatch(b -> Objects.equals(b.getBlindBox().getBlindBoxId(), blindBoxCampaign.getBlindBox().getBlindBoxId()))) {
                    blindBoxCampaign.setIsVisible(false);
                    log.info("Deleted blind box campaign {}", blindBoxCampaign.getBlindBox().getBlindBoxId());
                }
            });
            promotionalCampaign.getBlindBoxCampaigns().forEach(blindBoxCampaign ->
            {
                if (existing.getBlindBoxCampaigns().stream().noneMatch(b -> Objects.equals(b.getBlindBox().getBlindBoxId(), blindBoxCampaign.getBlindBox().getBlindBoxId()))) {
                    blindBoxCampaign.setId(
                            new BlindBoxCampaignId( blindBoxCampaign.getBlindBox().getBlindBoxId(),promotionalCampaign.getCampaignId())
                    );
                    blindBoxCampaign.setPromotionalCampaign(existing);
                    existing.getBlindBoxCampaigns().add(blindBoxCampaign);
                    log.info("Added blind box campaign {}", blindBoxCampaign.getBlindBox().getBlindBoxId());
                }
            });
            log.info("Updated blind box campaigns {}", existing.getBlindBoxCampaigns().size());
        }
        EntityUtil.merge(existing, promotionalCampaign);
        return promotionalCampaignRepos.save(existing);
    }

    @Override
    public PromotionalCampaign deleteById(long id) {
        PromotionalCampaign promotionalCampaign = promotionalCampaignRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("PromotionalCampaign does not exist"));
//        promotionalCampaign.setIsVisible(false);
        return promotionalCampaignRepos.save(promotionalCampaign);
    }

    @Override
    public Page<PromotionalCampaign> getAll(ListParams params) {
        var spec = params.<PromotionalCampaign>toSpec();
        return promotionalCampaignRepos.findAll(spec, params.getPageable());
    }
}