package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.PromotionalCampaignDto;
import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class PromotionalCampaignMapper extends BaseMapper<PromotionalCampaignDto, PromotionalCampaign> {

    @Override
    public PromotionalCampaign toEntity(PromotionalCampaignDto dto) {
        if (dto == null) {
            return null;
        }

        PromotionalCampaign entity = new PromotionalCampaign();
        entity.setCampaignId(dto.getCampaignId());
        entity.setTitle(dto.getTitle());
        entity.setDescription(dto.getDescription());
        entity.setStartDate(DateTimeUtil.fromOffsetToLocal(dto.getStartDate()));
        entity.setEndDate(DateTimeUtil.fromOffsetToLocal(dto.getEndDate()));
        entity.setDiscountRate(dto.getDiscountRate());
        entity.setIsVisible(dto.getIsVisible());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        return entity;
    }

    @Override
    public PromotionalCampaignDto toDTO(PromotionalCampaign entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        PromotionalCampaignDto dto = new PromotionalCampaignDto();
        dto.setCampaignId(entity.getCampaignId());
        dto.setTitle(entity.getTitle());
        dto.setIsVisible(entity.getIsVisible());
        dto.setDescription(entity.getDescription());
        dto.setStartDate(DateTimeUtil.fromLocalToOffset(entity.getStartDate()));
        dto.setEndDate(DateTimeUtil.fromLocalToOffset(entity.getEndDate()));
        dto.setDiscountRate(entity.getDiscountRate());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        return dto;
    }
}