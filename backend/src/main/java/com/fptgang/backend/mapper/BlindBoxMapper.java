package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.BlindBoxDto;
import com.fptgang.backend.model.BlindBox;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.BrandRepos;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Slf4j
@Component
public class BlindBoxMapper extends BaseMapper<BlindBoxDto, BlindBox> {

    @Autowired
    private BlindBoxRepos blindBoxRepos;
    @Autowired
    private PromotionalCampaignRepos promotionalCampaignRepos;
    @Autowired
    private BrandRepos brandRepos;
    @Autowired
    private ImageMapper imageMapper;

    @Override
    public BlindBox toEntity(BlindBoxDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<BlindBox> existingBlindBoxOptional = blindBoxRepos.findById(dto.getBlindBoxId());

        if (existingBlindBoxOptional.isPresent()) {
            BlindBox existingBlindBox = existingBlindBoxOptional.get();
            existingBlindBox.setName(dto.getName() != null ? dto.getName() : existingBlindBox.getName());
            existingBlindBox.setDescription(dto.getDescription() != null ? dto.getDescription() : existingBlindBox.getDescription());
            existingBlindBox.setCurrentPrice(dto.getCurrentPrice() != null ? dto.getCurrentPrice() : existingBlindBox.getCurrentPrice());
            if (dto.getImages() != null) {
                existingBlindBox.setImages(dto.getImages().stream().map(imageMapper::toEntity).toList());
            }
            existingBlindBox.setBrand(dto.getBrandId() != null
                    && dto.getBrandId() != existingBlindBox.getBrand().getBrandId() ?
                    brandRepos.findById(dto.getBrandId()).get()
                    : existingBlindBox.getBrand());
            existingBlindBox.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingBlindBox.isVisible());
            return existingBlindBox;
        } else {
            BlindBox entity = new BlindBox();
            entity.setBlindBoxId(dto.getBlindBoxId());
            entity.setName(dto.getName());
            entity.setDescription(dto.getDescription());
            entity.setCurrentPrice(dto.getCurrentPrice());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            entity.setBrand(dto.getBrandId() != null?
                    brandRepos.findById(dto.getBrandId()).get()
                    : null);
            if (dto.getPromotionalCampaignId() != null) {
                entity.setPromotionalCampaign(promotionalCampaignRepos.findById(dto.getPromotionalCampaignId()).get());
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
    public BlindBoxDto toDTO(BlindBox entity) {
        if (entity == null) {
            return null;
        }
        BlindBoxDto dto = new BlindBoxDto();
        dto.setBlindBoxId(entity.getBlindBoxId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setCurrentPrice(entity.getCurrentPrice());
        dto.setBrandId(entity.getBrand() != null ? entity.getBrand().getBrandId() : null);
        dto.setPromotionalCampaignId(entity.getPromotionalCampaign() != null ? entity.getPromotionalCampaign().getCampaignId() : null);
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }

        dto.setImages(entity.getImages().stream().map(imageMapper::toDTO).toList());
        dto.setIsVisible(entity.isVisible());
        return dto;
    }
}