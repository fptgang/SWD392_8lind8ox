package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.BrandDto;
import com.fptgang.backend.model.Brand;
import com.fptgang.backend.repository.BrandRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class BrandMapper extends BaseMapper<BrandDto, Brand> {

    @Autowired
    private BrandRepos brandRepos;

    @Override
    public Brand toEntity(BrandDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Brand> existingBrandOptional = brandRepos.findById(dto.getBrandId());

        if (existingBrandOptional.isPresent()) {
            Brand existingBrand = existingBrandOptional.get();
            existingBrand.setName(dto.getName() != null ? dto.getName() : existingBrand.getName());
            existingBrand.setDescription(dto.getDescription() != null ? dto.getDescription() : existingBrand.getDescription());
            existingBrand.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingBrand.isVisible());
            return existingBrand;
        } else {
            Brand entity = new Brand();
            entity.setBrandId(dto.getBrandId());
            entity.setName(dto.getName());
            entity.setDescription(dto.getDescription());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
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
    public BrandDto toDTO(Brand entity) {
        if (entity == null) {
            return null;
        }

        BrandDto dto = new BrandDto();
        dto.setBrandId(entity.getBrandId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setIsVisible(entity.isVisible());
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        if (entity.getBlindBoxes() != null) {
            dto.setBlindBoxes(entity.getBlindBoxes().stream().map(blindBox -> blindBox.getBlindBoxId()).collect(Collectors.toList()));
        }
        return dto;
    }
}