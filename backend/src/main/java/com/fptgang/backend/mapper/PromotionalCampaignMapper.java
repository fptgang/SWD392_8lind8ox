package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.BlindBoxCampaignDto;
import com.fptgang.backend.api.model.PromotionalCampaignDto;
import com.fptgang.backend.api.model.PromotionalCampaignRequestDto;
import com.fptgang.backend.model.PromotionalCampaign;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Slf4j
@Component
public class PromotionalCampaignMapper extends BaseMapper<PromotionalCampaignDto, PromotionalCampaign> {

    private final BlindBoxCampaignMapper blindBoxCampaignMapper;

    public PromotionalCampaignMapper(BlindBoxCampaignMapper blindBoxCampaignMapper) {
        super();
        this.blindBoxCampaignMapper = blindBoxCampaignMapper;
    }

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
        if(dto.getCampaignId()!=null&&dto.getBlindBoxCampaigns() != null) {
            entity.setBlindBoxCampaigns(dto.getBlindBoxCampaigns()
                    .stream()
                    .map(blindBoxCampaignMapper::toEntity)
                    .collect(Collectors.toList()));
        }
        return entity;
    }

    public PromotionalCampaignDto toDTO(PromotionalCampaignRequestDto requestDto) {
        if (requestDto == null) {
            return null;
        }

        PromotionalCampaignDto dto = new PromotionalCampaignDto();
        dto.setCampaignId(requestDto.getCampaignId());
        dto.setTitle(requestDto.getTitle());
        dto.setDescription(requestDto.getDescription());
        dto.setStartDate(requestDto.getStartDate());
        dto.setEndDate(requestDto.getEndDate());
        dto.setDiscountRate(requestDto.getDiscountRate());
        dto.setIsVisible(requestDto.getIsVisible()!=null?requestDto.getIsVisible():false);
        if(requestDto.getBlindBoxIds() != null) {
            dto.setBlindBoxCampaigns(requestDto.getBlindBoxIds()
                    .stream()
                    .map(blindBoxId -> {
                        BlindBoxCampaignDto blindBoxCampaignDto = new BlindBoxCampaignDto();
                        blindBoxCampaignDto.setBlindBoxId(blindBoxId);
                        blindBoxCampaignDto.setPromotionalCampaignId(requestDto.getCampaignId()!=null?requestDto.getCampaignId():null);
                        blindBoxCampaignDto.setIsVisible(true);
                        log.info("blindBoxCampaignDto: {}", blindBoxCampaignDto);
                        return blindBoxCampaignDto;
                    })
                    .collect(Collectors.toList()));
        }
        return dto;
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
        if(entity.getBlindBoxCampaigns() != null) {
            dto.setBlindBoxCampaigns(entity.getBlindBoxCampaigns()
                    .stream()
                    .map(blindBoxCampaign ->
                            blindBoxCampaignMapper.toDTO(blindBoxCampaign, DetailLevel.REFERENCE))
                    .collect(Collectors.toList()));
        }
        return dto;
    }
}