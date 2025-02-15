package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.PromotionalCampaignsApi;
import com.fptgang.backend.api.model.GetPromotionalCampaigns200Response;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.api.model.PromotionalCampaignDto;
import com.fptgang.backend.mapper.PromotionalCampaignMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.PromotionalCampaignService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class CampaignController implements PromotionalCampaignsApi {

    private final PromotionalCampaignService promotionCampaignService;
    private final PromotionalCampaignMapper promotionCampaignMapper;

    @Autowired
    public CampaignController(PromotionalCampaignMapper promotionCampaignMapper, PromotionalCampaignService promotionCampaignService) {
        this.promotionCampaignService = promotionCampaignService;
        this.promotionCampaignMapper = promotionCampaignMapper;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return PromotionalCampaignsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<PromotionalCampaignDto> createPromotionalCampaign(PromotionalCampaignDto promotionalCampaignDto) {
        log.info("Creating promotional campaign");
        if (!SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can create promotional campaigns.");
        }
        ResponseEntity<PromotionalCampaignDto> response = new ResponseEntity<>(promotionCampaignMapper
                .toDTO(promotionCampaignService.create(promotionCampaignMapper.toEntity(promotionalCampaignDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deletePromotionalCampaign(Long campaignId) {
        log.info("Deleting promotional campaign " + campaignId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can delete promotional campaigns.");
        }
        promotionCampaignService.deleteById(campaignId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<PromotionalCampaignDto> getPromotionalCampaignById(Long campaignId) {
        log.info("Fetching promotional campaign with ID {}", campaignId);

        boolean isAdminOrStaff = SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF);
        if (!isAdminOrStaff) {
            throw new AccessDeniedException("Only staff and admins can view specific campaign details.");
        }
        return new ResponseEntity<>(promotionCampaignMapper.toDTO(promotionCampaignService.findById(campaignId)), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetPromotionalCampaigns200Response> getPromotionalCampaigns(Pageable pageable, String filter, String search) {
        log.info("Fetching promotional campaigns");

        boolean isAdminOrStaff = SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF);
        if (!isAdminOrStaff) {
            throw new AccessDeniedException("Only staff and admins can view promotional campaigns.");
        }

        var page = OpenApiHelper.toPageable(pageable);
        var resultPage = promotionCampaignService.getAll(page, filter, search, isAdminOrStaff)
                .map(promotionCampaignMapper::toDTO);

        return OpenApiHelper.respondPage(resultPage, GetPromotionalCampaigns200Response.class);
    }

    @Override
    public ResponseEntity<PromotionalCampaignDto> updatePromotionalCampaign(Long campaignId, PromotionalCampaignDto promotionalCampaignDto) {
        if (!SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can update promotional campaigns.");
        }
        promotionalCampaignDto.setCampaignId(campaignId); // Override campaignId

        log.info("Updating promotional campaign " + campaignId);
        return ResponseEntity.ok(promotionCampaignMapper.toDTO(promotionCampaignService.update(promotionCampaignMapper.toEntity(promotionalCampaignDto))));
    }
}
