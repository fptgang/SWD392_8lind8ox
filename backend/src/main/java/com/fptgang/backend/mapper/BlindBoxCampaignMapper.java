package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.BlindBoxCampaignDto;
import com.fptgang.backend.model.BlindBoxCampaign;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class BlindBoxCampaignMapper extends BaseMapper<BlindBoxCampaignDto, BlindBoxCampaign> {
    private final BlindBoxRepos blindBoxRepos;
    private final PromotionalCampaignRepos promotionalCampaignRepos;
    private final PromotionalCampaignMapper promotionalCampaignMapper;

    public BlindBoxCampaignMapper(BlindBoxRepos blindBoxRepos,
                                  PromotionalCampaignRepos promotionalCampaignRepos, PromotionalCampaignMapper promotionalCampaignMapper) {
        this.blindBoxRepos = blindBoxRepos;
        this.promotionalCampaignRepos = promotionalCampaignRepos;
        this.promotionalCampaignMapper = promotionalCampaignMapper;
    }

    @Override
    public BlindBoxCampaign toEntity(BlindBoxCampaignDto dto) {
        BlindBoxCampaign entity = new BlindBoxCampaign();
        entity.setBlindBox(blindBoxRepos.getReferenceById(dto.getBlindBoxId()));
        entity.setPromotionalCampaign(promotionalCampaignRepos.getReferenceById(dto.getPromotionalCampaign().getCampaignId()));
        entity.setIsVisible(dto.getIsVisible());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        return null;
    }

    @Override
    public BlindBoxCampaignDto toDTO(BlindBoxCampaign entity, DetailLevel level) {
        BlindBoxCampaignDto dto = new BlindBoxCampaignDto();
        dto.setBlindBoxId(entity.getBlindBox() != null ? entity.getBlindBox().getBlindBoxId() : null);
        dto.setPromotionalCampaign(promotionalCampaignMapper.toDTO(entity.getPromotionalCampaign(), DetailLevel.REFERENCE));
        dto.setIsVisible(entity.getIsVisible());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        return dto;
    }
}
