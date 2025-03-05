package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.BrandDto;
import com.fptgang.backend.model.Brand;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class BrandMapper extends BaseMapper<BrandDto, Brand> {

    @Override
    public Brand toEntity(BrandDto dto) {
        if (dto == null) {
            return null;
        }

        Brand entity = new Brand();
        entity.setBrandId(dto.getBrandId());
        entity.setName(dto.getName());
        entity.setDescription(dto.getDescription());
        entity.setIsVisible(dto.getIsVisible());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        return entity;
    }

    @Override
    public BrandDto toDTO(Brand entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        BrandDto dto = new BrandDto();
        dto.setBrandId(entity.getBrandId());
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
        return dto;
    }
}