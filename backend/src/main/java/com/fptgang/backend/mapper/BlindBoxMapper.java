package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.BlindBoxDto;
import com.fptgang.backend.model.BlindBox;
import com.fptgang.backend.repository.BrandRepos;
import com.fptgang.backend.repository.ImageRepos;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Slf4j
@Component
public class BlindBoxMapper extends BaseMapper<BlindBoxDto, BlindBox> {
    private final BlindBoxCampaignMapper blindBoxCampaignMapper;
    private final BrandMapper brandMapper;
    private final ToyMapper toyMapper;
    private final StockKeepingUnitMapper.Converter skuConverter;
    private final BrandRepos brandRepos;
    private final ImageRepos imageRepos;
    private final ImageMapper imageMapper;

    public BlindBoxMapper(BlindBoxCampaignMapper blindBoxCampaignMapper,
                          BrandMapper brandMapper,
                          ToyMapper toyMapper,
                          StockKeepingUnitMapper.Converter skuConverter,
                          BrandRepos brandRepos,
                          ImageRepos imageRepos,
                          ImageMapper imageMapper) {
        this.blindBoxCampaignMapper = blindBoxCampaignMapper;
        this.brandMapper = brandMapper;
        this.toyMapper = toyMapper;
        this.skuConverter = skuConverter;
        this.brandRepos = brandRepos;
        this.imageRepos = imageRepos;
        this.imageMapper = imageMapper;
    }

    @Override
    public BlindBox toEntity(BlindBoxDto dto) {
        if (dto == null) {
            return null;
        }

        BlindBox entity = new BlindBox();
        entity.setBlindBoxId(dto.getBlindBoxId());
        if (dto.getBrand() != null) {
            entity.setBrand(brandRepos.getReferenceById(dto.getBrand().getBrandId()));
        }
        entity.setName(dto.getName());
        entity.setDescription(dto.getDescription());
        if (dto.getImages() != null) {
            entity.setImages(dto.getImages().stream()
                    .map(e -> imageRepos.getReferenceById(e.getImageId()))
                    .collect(Collectors.toList()));
        }
        if (dto.getBlindBoxCampaigns() != null) {
            entity.setBlindBoxCampaigns(dto.getBlindBoxCampaigns().stream()
                    .map(blindBoxCampaignMapper::toEntity)
                    .collect(Collectors.toList()));
        }
        entity.setIsVisible(dto.getIsVisible());
        if (dto.getToys() != null) {
            entity.setToys(dto.getToys().stream()
                    .map(toyMapper::toEntity)
                    .collect(Collectors.toList()));
        }
        if (dto.getSkus() != null) {
            entity.setSkus(dto.getSkus().stream()
                    .map(skuConverter::toEntity)
                    .collect(Collectors.toList()));
        }
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        return entity;
    }

    @Override
    public BlindBoxDto toDTO(BlindBox entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        BlindBoxDto dto = new BlindBoxDto();
        dto.setBlindBoxId(entity.getBlindBoxId());
        dto.setBrand(brandMapper.toDTO(entity.getBrand(), DetailLevel.REFERENCE));
        dto.setName(entity.getName());
        dto.setIsVisible(entity.getIsVisible());

        if (level == DetailLevel.REFERENCE) {
            return dto; // those fields are enough
        }

        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));

        if (level == DetailLevel.SUMMARY) {
            return dto; // those fields are enough
        }

        dto.setDescription(entity.getDescription());
        dto.setImages(entity.getImages().stream()
                .map(e -> imageMapper.toDTO(e, DetailLevel.REFERENCE))
                .collect(Collectors.toList()));
        dto.setBlindBoxCampaigns(entity.getBlindBoxCampaigns().stream()
                .map(e -> blindBoxCampaignMapper.toDTO(e, DetailLevel.REFERENCE))
                .collect(Collectors.toList()));
        dto.setToys(entity.getToys().stream()
                .map(e -> toyMapper.toDTO(e, DetailLevel.REFERENCE))
                .collect(Collectors.toList()));
        dto.setSkus(entity.getSkus().stream()
                .map(e -> skuConverter.toDTO(e, DetailLevel.REFERENCE))
                .collect(Collectors.toList()));
        return dto;
    }
}