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

    public BlindBoxCampaignMapper(BlindBoxRepos blindBoxRepos,
                                  PromotionalCampaignRepos promotionalCampaignRepos) {
        this.blindBoxRepos = blindBoxRepos;
        this.promotionalCampaignRepos = promotionalCampaignRepos;
    }

    @Override
    public BlindBoxCampaign toEntity(BlindBoxCampaignDto dto) {
        BlindBoxCampaign entity = new BlindBoxCampaign();
        entity.setHistoryId(dto.getHistoryId());
        entity.setBlindBox(blindBoxRepos.getReferenceById(dto.getBlindBoxId()));
        entity.setPromotionalCampaign(promotionalCampaignRepos.getReferenceById(dto.getPromotionalCampaignId()));
        entity.setIsVisible(dto.getIsVisible());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        return null;
    }

    @Override
    public BlindBoxCampaignDto toDTO(BlindBoxCampaign entity, DetailLevel level) {
        BlindBoxCampaignDto dto = new BlindBoxCampaignDto();
        dto.setHistoryId(entity.getHistoryId());
        dto.setBlindBoxId(entity.getBlindBox() != null ? entity.getBlindBox().getBlindBoxId() : null);
        dto.setPromotionalCampaignId(entity.getPromotionalCampaign() != null ? entity.getPromotionalCampaign().getCampaignId() : null);
        dto.setIsVisible(entity.getIsVisible());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        return dto;
    }
}
