package com.fptgang.backend.service;

import com.fptgang.backend.model.PromotionalCampaign;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface PromotionalCampaignService {
    PromotionalCampaign create(PromotionalCampaign promotionalCampaign);
    PromotionalCampaign findById(long id);
    PromotionalCampaign update(PromotionalCampaign promotionalCampaign);
    PromotionalCampaign deleteById(long id);
    Page<PromotionalCampaign> getAll(Pageable pageable, String filter, boolean includeInvisible);
    default Page<PromotionalCampaign> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, false);
    }
}