package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.PackDto;
import com.fptgang.backend.api.model.PackDto;
import com.fptgang.backend.model.Pack;
import com.fptgang.backend.model.Pack;
import com.fptgang.backend.model.Pack;
import com.fptgang.backend.model.Product;
import com.fptgang.backend.repository.BrandRepos;
import com.fptgang.backend.repository.PackRepos;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class PackMapper extends BaseMapper<PackDto, Pack> {

    @Autowired
    private PackRepos packRepos;
    @Autowired
    private ImageMapper imageMapper;
    @Autowired
    private BrandRepos brandRepos;
    @Autowired
    private PromotionalCampaignRepos promotionalCampaignRepos;
    @Autowired
    private ToyMapper toyMapper;


    @Override
    public Pack toEntity(PackDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Pack> existingPackOptional = packRepos.findById(dto.getProductId());

        if (existingPackOptional.isPresent()) {
            Pack existingPack = existingPackOptional.get();
            existingPack.setGuaranteedToys(dto.getGuaranteedToys().stream().map(toyMapper::toEntity).collect(Collectors.toList()));
            existingPack.setToyCount(dto.getToyCount());
            existingPack.setName(dto.getName() != null ? dto.getName() : existingPack.getName());
            existingPack.setDescription(dto.getDescription() != null ? dto.getDescription() : existingPack.getDescription());
            existingPack.setCurrentPrice(dto.getCurrentPrice() != null ? dto.getCurrentPrice() : existingPack.getCurrentPrice());
            if (dto.getImages() != null) {
                existingPack.setImages(dto.getImages().stream().map(imageMapper::toEntity).toList());
            }
            existingPack.setBrand(dto.getBrandId() != null
                    && dto.getBrandId() != existingPack.getBrand().getBrandId() ?
                    brandRepos.findById(dto.getBrandId()).get()
                    : existingPack.getBrand());
            existingPack.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingPack.isVisible());
            return existingPack;
        } else {
            Pack entity = new Pack();
            entity.setProductId(dto.getProductId());
            entity.setGuaranteedToys(dto.getGuaranteedToys().stream().map(toyMapper::toEntity).collect(Collectors.toList()));
            entity.setToyCount(dto.getToyCount());
            entity.setName(dto.getName());
            entity.setDescription(dto.getDescription());
            entity.setCurrentPrice(dto.getCurrentPrice());
            entity.setType(Product.Type.valueOf(dto.getType().getValue()));
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
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
    public PackDto toDTO(Pack entity) {
        if (entity == null) {
            return null;
        }
        PackDto dto = new PackDto();
        dto.setGuaranteedToys(entity.getGuaranteedToys().stream().map(toyMapper::toDTO).collect(Collectors.toList()));
        dto.setToyCount(entity.getToyCount());
        dto.setProductId(entity.getProductId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setCurrentPrice(entity.getCurrentPrice());
        dto.setType(PackDto.TypeEnum.valueOf(entity.getType().toString()));
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