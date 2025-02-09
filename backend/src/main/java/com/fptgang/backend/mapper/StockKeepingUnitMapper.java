package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.StockKeepingUnitDto;
import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.ImageRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class StockKeepingUnitMapper extends BaseMapper<StockKeepingUnitDto, StockKeepingUnit> {

    @Autowired
    private BlindBoxRepos blindBoxRepos;
    @Autowired
    private ImageRepos imageRepos;

    @Override
    public StockKeepingUnit toEntity(StockKeepingUnitDto dto) {
        if (dto == null) {
            return null;
        }

        StockKeepingUnit entity = new StockKeepingUnit();
        entity.setSkuId(dto.getSkuId());
        entity.setName(dto.getName());
        entity.setPrice(dto.getPrice());
        entity.setStock(dto.getStock());
        entity.setSpecCount(dto.getSpecCount());
        if (dto.getBlindBoxId() != null) {
            entity.setBlindBox(blindBoxRepos.findById(dto.getBlindBoxId()).orElse(null));
        }
        if (dto.getImageId() != null) {
            entity.setImage(imageRepos.findById(dto.getImageId()).orElse(null));
        }
        if (dto.getCreatedAt() != null) {
            entity.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
        }
        if (dto.getUpdatedAt() != null) {
            entity.setUpdatedAt(dto.getUpdatedAt().toLocalDateTime());
        }
        return entity;
    }

    @Override
    public StockKeepingUnitDto toDTO(StockKeepingUnit entity) {
        if (entity == null) {
            return null;
        }

        StockKeepingUnitDto dto = new StockKeepingUnitDto();
        dto.setSkuId(entity.getSkuId());
        dto.setName(entity.getName());
        dto.setPrice(entity.getPrice());
        dto.setStock(entity.getStock());
        dto.setSpecCount(entity.getSpecCount());
        dto.setBlindBoxId(entity.getBlindBox() != null ? entity.getBlindBox().getBlindBoxId() : null);
        dto.setImageId(entity.getImage() != null ? entity.getImage().getImageId() : null);
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        return dto;
    }
}