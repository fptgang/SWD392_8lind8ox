package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.service.PromotionalCampaignService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class PromotionalCampaignServiceImpl implements PromotionalCampaignService {

    private final PromotionalCampaignRepos promotionalCampaignRepos;

    @Autowired
    public PromotionalCampaignServiceImpl(PromotionalCampaignRepos promotionalCampaignRepos) {
        this.promotionalCampaignRepos = promotionalCampaignRepos;
    }

    @Override
    public PromotionalCampaign create(PromotionalCampaign promotionalCampaign) {
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