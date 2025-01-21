package com.fptgang.backend.controller;
import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.PromotionCampaignsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.AccountMapper;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class PromotionController implements PromotionCampaignsApi{

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return PromotionCampaignsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<PromotionalCampaignDto> createPromotionalCampaign(PromotionalCampaignDto promotionalCampaignDto) {
        return PromotionCampaignsApi.super.createPromotionalCampaign(promotionalCampaignDto);
    }

    @Override
    public ResponseEntity<Void> deletePromotionalCampaign(Integer campaignId) {
        return PromotionCampaignsApi.super.deletePromotionalCampaign(campaignId);
    }

    @Override
    public ResponseEntity<PromotionalCampaignDto> getPromotionalCampaignById(Integer campaignId) {
        return PromotionCampaignsApi.super.getPromotionalCampaignById(campaignId);
    }

    @Override
    public ResponseEntity<GetPromotionalCampaigns200Response> getPromotionalCampaigns(GetAccountsPageableParameter pageable, String filter) {
        return PromotionCampaignsApi.super.getPromotionalCampaigns(pageable, filter);
    }

    @Override
    public ResponseEntity<PromotionalCampaignDto> updatePromotionalCampaign(Integer campaignId, PromotionalCampaignDto promotionalCampaignDto) {
        return PromotionCampaignsApi.super.updatePromotionalCampaign(campaignId, promotionalCampaignDto);
    }
}
