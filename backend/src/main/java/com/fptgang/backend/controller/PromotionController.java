package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.PromotionCampaignsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.PromotionalCampaignMapper;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.service.PromotionalCampaignService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class PromotionController implements PromotionCampaignsApi{

    private final PromotionalCampaignService promotionCampaignService;
    private final PromotionalCampaignMapper promotionCampaignMapper;

    @Autowired
    public PromotionController(PromotionalCampaignMapper promotionCampaignMapper, PromotionalCampaignService promotionCampaignService) {
        this.promotionCampaignService = promotionCampaignService;
        this.promotionCampaignMapper = promotionCampaignMapper;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return PromotionCampaignsApi.super.getRequest();
    }
    @Override
    public ResponseEntity<PromotionalCampaignDto> createPromotionalCampaign(PromotionalCampaignDto promotionalCampaignDto) {
        log.info("Creating promotional campaign");
        ResponseEntity<PromotionalCampaignDto> response = new ResponseEntity<>(promotionCampaignMapper
                .toDTO(promotionCampaignService.create(promotionCampaignMapper.toEntity(promotionalCampaignDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deletePromotionalCampaign(Integer campaignId) {
        log.info("Deleting promotional campaign " + campaignId);
        promotionCampaignService.deleteById(Long.valueOf(campaignId));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<PromotionalCampaignDto> getPromotionalCampaignById(Integer campaignId) {
        log.info("Getting promotional campaign by id " + campaignId);
        return new ResponseEntity<>(promotionCampaignMapper.toDTO(promotionCampaignService.findById(Long.valueOf(campaignId))), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetPromotionalCampaigns200Response> getPromotionalCampaigns(Pageable pageable, String filter, String search) {
        log.info("Getting promotional campaigns");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        var res = promotionCampaignService.getAll(page, filter, search, includeInvisible).map(promotionCampaignMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetPromotionalCampaigns200Response.class);
    }

    @Override
    public ResponseEntity<PromotionalCampaignDto> updatePromotionalCampaign(Integer campaignId, PromotionalCampaignDto promotionalCampaignDto) {
        log.info("Updating promotional campaign " + campaignId);
        return ResponseEntity.ok(promotionCampaignMapper.toDTO(promotionCampaignService.update(promotionCampaignMapper.toEntity(promotionalCampaignDto))));
    }
}
