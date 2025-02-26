package com.fptgang.backend.service;

import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface PromotionalCampaignService {
    PromotionalCampaign create(PromotionalCampaign promotionalCampaign);
    PromotionalCampaign findById(long id);
    PromotionalCampaign update(PromotionalCampaign promotionalCampaign);
    PromotionalCampaign deleteById(long id);
    Page<PromotionalCampaign> getAll(ListParams params);
}