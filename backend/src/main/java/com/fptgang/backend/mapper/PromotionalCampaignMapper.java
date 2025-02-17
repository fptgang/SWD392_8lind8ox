package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.PromotionalCampaignDto;
import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.repository.SetRepos;
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
    private SetRepos setRepos;
    @Autowired
    private BlindBoxMapper blindBoxMapper;

    @Override
    public PromotionalCampaign toEntity(PromotionalCampaignDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<PromotionalCampaign> existingPromotionalCampaignOptional = promotionalCampaignRepos.findById(dto.getCampaignId() == null ? 0 : dto.getCampaignId());

        if (existingPromotionalCampaignOptional.isPresent() && dto.getCampaignId() != null) {
            PromotionalCampaign existingPromotionalCampaign = existingPromotionalCampaignOptional.get();
            existingPromotionalCampaign.setTitle(dto.getTitle() != null ? dto.getTitle() : existingPromotionalCampaign.getTitle());
            existingPromotionalCampaign.setDescription(dto.getDescription() != null ? dto.getDescription() : existingPromotionalCampaign.getDescription());
            existingPromotionalCampaign.setStartDate(dto.getStartDate() != null ? DateTimeUtil.fromOffsetToLocal(dto.getStartDate()) : existingPromotionalCampaign.getStartDate());
            existingPromotionalCampaign.setEndDate(dto.getEndDate() != null ? DateTimeUtil.fromOffsetToLocal(dto.getEndDate()) : existingPromotionalCampaign.getEndDate());
            existingPromotionalCampaign.setDiscountRate(dto.getDiscountRate() != null ? dto.getDiscountRate() : existingPromotionalCampaign.getDiscountRate());
            existingPromotionalCampaign.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingPromotionalCampaign.isVisible());
            if (dto.getBlindBoxes() != null) {
                existingPromotionalCampaign.setBlindBoxes(
                        dto.getBlindBoxes().stream().map(
                                blindBoxMapper::toEntity
                        ).toList()
                );
            }
            return existingPromotionalCampaign;
        } else {
            PromotionalCampaign entity = new PromotionalCampaign();
//            entity.setCampaignId(dto.getCampaignId());
            entity.setTitle(dto.getTitle());
            entity.setDescription(dto.getDescription());
            entity.setStartDate(DateTimeUtil.fromOffsetToLocal(dto.getStartDate()));
            entity.setEndDate(DateTimeUtil.fromOffsetToLocal(dto.getEndDate()));
            entity.setDiscountRate(dto.getDiscountRate());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            if (dto.getBlindBoxes() != null) {
                entity.setBlindBoxes(
                        dto.getBlindBoxes().stream().map(
                                blindBoxMapper::toEntity
                        ).toList()
                );
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
        dto.setIsVisible(entity.isVisible());
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        dto.setBlindBoxes(
                entity.getBlindBoxes().stream().map(
                        blindBoxMapper::toDTO
                ).toList()
        );
        return dto;
    }
}