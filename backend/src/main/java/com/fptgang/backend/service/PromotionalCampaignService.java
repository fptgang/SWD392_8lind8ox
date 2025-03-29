package com.fptgang.backend.service;

import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

import java.time.LocalDateTime;

public interface PromotionalCampaignService {
    PromotionalCampaign create(PromotionalCampaign promotionalCampaign);
    PromotionalCampaign findById(long id);
    PromotionalCampaign findBestOngoingCampaignForBlindBox(long blindBoxId);
    PromotionalCampaign findBestOngoingCampaignForSku(long skuId);
    PromotionalCampaign update(PromotionalCampaign promotionalCampaign);
    PromotionalCampaign deleteById(long id);
    Page<PromotionalCampaign> getAll(ListParams params, LocalDateTime fromDate, LocalDateTime toDate);
    default Page<PromotionalCampaign> getAll(ListParams params) {
        return getAll(params, null, null);
    }
}