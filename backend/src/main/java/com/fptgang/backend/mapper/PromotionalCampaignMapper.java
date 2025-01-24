package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.PromotionalCampaignDto;
import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.PackRepos;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class PromotionalCampaignMapper extends BaseMapper<PromotionalCampaignDto, PromotionalCampaign> {

    @Autowired
    private PromotionalCampaignRepos promotionalCampaignRepos;
    @Autowired
    private AccountRepos accountRepos;
    @Autowired
    private BlindBoxRepos blindBoxRepos;
    @Autowired
    private PackRepos packRepos;
    @Autowired
    private BlindBoxMapper blindBoxMapper;

    @Override
    public PromotionalCampaign toEntity(PromotionalCampaignDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<PromotionalCampaign> existingPromotionalCampaignOptional = promotionalCampaignRepos.findById(dto.getCampaignId());

        if (existingPromotionalCampaignOptional.isPresent()) {
            PromotionalCampaign existingPromotionalCampaign = existingPromotionalCampaignOptional.get();
            existingPromotionalCampaign.setTitle(dto.getTitle() != null ? dto.getTitle() : existingPromotionalCampaign.getTitle());
            existingPromotionalCampaign.setDescription(dto.getDescription() != null ? dto.getDescription() : existingPromotionalCampaign.getDescription());
            existingPromotionalCampaign.setStartDate(dto.getStartDate() != null ? DateTimeUtil.fromOffsetToLocal(dto.getStartDate()) : existingPromotionalCampaign.getStartDate());
            existingPromotionalCampaign.setEndDate(dto.getEndDate() != null ? DateTimeUtil.fromOffsetToLocal(dto.getEndDate()) : existingPromotionalCampaign.getEndDate());
            existingPromotionalCampaign.setDiscountRate(dto.getDiscountRate() != null ? dto.getDiscountRate() : existingPromotionalCampaign.getDiscountRate());
            existingPromotionalCampaign.setPromoCode(dto.getPromoCode() != null ? dto.getPromoCode() : existingPromotionalCampaign.getPromoCode());
            existingPromotionalCampaign.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingPromotionalCampaign.isVisible());
            return existingPromotionalCampaign;
        } else {
            PromotionalCampaign entity = new PromotionalCampaign();
            entity.setCampaignId(dto.getCampaignId());
            entity.setTitle(dto.getTitle());
            entity.setDescription(dto.getDescription());
            entity.setStartDate(DateTimeUtil.fromOffsetToLocal(dto.getStartDate()));
            entity.setEndDate(DateTimeUtil.fromOffsetToLocal(dto.getEndDate()));
            entity.setDiscountRate(dto.getDiscountRate());
            entity.setPromoCode(dto.getPromoCode());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            if (dto.getCreatorId() != null) {
                entity.setCreator(accountRepos.findById(dto.getCreatorId()).get());
            }
            if (dto.getCreatedAt() != null) {
                entity.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
            }
            if (dto.getUpdatedAt() != null) {
                entity.setUpdatedAt(dto.getUpdatedAt().toLocalDateTime());
            }
            return entity;
        }
    }

    @Override
    public PromotionalCampaignDto toDTO(PromotionalCampaign entity) {
        if (entity == null) {
            return null;
        }

        PromotionalCampaignDto dto = new PromotionalCampaignDto();
        dto.setCampaignId(entity.getCampaignId());
        dto.setTitle(entity.getTitle());
        dto.setDescription(entity.getDescription());
        dto.setStartDate(DateTimeUtil.fromLocalToOffset(entity.getStartDate()));
        dto.setEndDate(DateTimeUtil.fromLocalToOffset(entity.getEndDate()));
        dto.setDiscountRate(entity.getDiscountRate());
        dto.setPromoCode(entity.getPromoCode());
        dto.setIsVisible(entity.isVisible());
        dto.setCreatorId(entity.getCreator() != null ? entity.getCreator().getAccountId() : null);
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        return dto;
    }
}