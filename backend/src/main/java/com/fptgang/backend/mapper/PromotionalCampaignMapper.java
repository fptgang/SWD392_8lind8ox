package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.PromotionalCampaignDto;
import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.repository.AccountRepos;
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
            existingPromotionalCampaign.setCode(dto.getCode() != null ? dto.getCode() : existingPromotionalCampaign.getCode());
            existingPromotionalCampaign.setQuantity(dto.getQuantity() != null ? dto.getQuantity() : existingPromotionalCampaign.getQuantity());
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
            entity.setCode(dto.getCode());
            entity.setQuantity(dto.getQuantity());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            if( dto.getCreatorId() != null ) {
                entity.setCreator(accountRepos.findById(dto.getCreatorId()).get());
            }
            // Set other fields similarly
            if(dto.getCreatedDate() != null) {
                entity.setCreatedDate(dto.getCreatedDate().toLocalDateTime());
            }
            if(dto.getUpdatedDate() != null) {
                entity.setUpdatedDate(dto.getUpdatedDate().toLocalDateTime());
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
        dto.setCode(entity.getCode());
        dto.setQuantity(entity.getQuantity());
        dto.setCreatorId(entity.getCreator() != null ? entity.getCreator().getAccountId() : null);
        dto.setBlindBoxes(entity.getBlindBoxes().stream().map(blindBoxMapper::toDTO).toList());
        dto.setIsVisible(entity.isVisible());
        if(entity.getCreatedDate() != null) {
            dto.setCreatedDate(DateTimeUtil.fromLocalToOffset(entity.getCreatedDate()));
        }
        if(entity.getUpdatedDate() != null) {
            dto.setUpdatedDate(DateTimeUtil.fromLocalToOffset(entity.getUpdatedDate()));
        }
        // Set other fields similarly

        return dto;
    }
}