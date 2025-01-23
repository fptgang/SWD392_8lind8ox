package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.service.PromotionalCampaignService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

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
    public PromotionalCampaign update(PromotionalCampaign promotionalCampaign) {
        if (promotionalCampaign.getCampaignId() == null) {
            throw new IllegalArgumentException("PromotionalCampaign does not exist");
        }
        return promotionalCampaignRepos.save(promotionalCampaign);
    }

    @Override
    public PromotionalCampaign deleteById(long id) {
        PromotionalCampaign promotionalCampaign = promotionalCampaignRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("PromotionalCampaign does not exist"));
//        promotionalCampaign.setVisible(false);
        return promotionalCampaignRepos.save(promotionalCampaign);
    }

    @Override
    public Page<PromotionalCampaign> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<PromotionalCampaign>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return promotionalCampaignRepos.findAll(spec, pageable);
    }
}