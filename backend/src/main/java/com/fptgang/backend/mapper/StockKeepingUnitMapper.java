package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.StockKeepingUnitDto;
import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.ImageRepos;
import com.fptgang.backend.repository.StockKeepingUnitRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class StockKeepingUnitMapper extends BaseMapper<StockKeepingUnitDto, StockKeepingUnit> {

    @Autowired
    private BlindBoxRepos blindBoxRepos;
    @Autowired
    private ImageRepos imageRepos;
    @Autowired
    private StockKeepingUnitRepos stockKeepingUnitRepos;

    @Override
    public StockKeepingUnit toEntity(StockKeepingUnitDto dto) {
        if (dto == null) {
            return null;
        }


        Optional<StockKeepingUnit> existingStockKeepingUnitOptional = stockKeepingUnitRepos.findById(dto.getSkuId() == null ? 0 : dto.getSkuId());
        if (existingStockKeepingUnitOptional.isPresent() && dto.getSkuId() != null) {
            StockKeepingUnit existingStockKeepingUnit = existingStockKeepingUnitOptional.get();
            existingStockKeepingUnit.setName(dto.getName() != null ? dto.getName() : existingStockKeepingUnit.getName());
            existingStockKeepingUnit.setPrice(dto.getPrice() != null ? dto.getPrice() : existingStockKeepingUnit.getPrice());
            existingStockKeepingUnit.setStock(dto.getStock() != null ? dto.getStock() : existingStockKeepingUnit.getStock());
            existingStockKeepingUnit.setSpecCount(dto.getSpecCount() != null ? dto.getSpecCount() : existingStockKeepingUnit.getSpecCount());
            if (dto.getBlindBoxId() != null) {
                existingStockKeepingUnit.setBlindBox(blindBoxRepos.findById(dto.getBlindBoxId()).orElse(null));
            }
            if (dto.getImageId() != null) {
                existingStockKeepingUnit.setImage(imageRepos.findById(dto.getImageId()).orElse(null));
            }
            if (dto.getCreatedAt() != null) {
                existingStockKeepingUnit.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
            }
            if (dto.getUpdatedAt() != null) {
                existingStockKeepingUnit.setUpdatedAt(dto.getUpdatedAt().toLocalDateTime());
            }
            return existingStockKeepingUnit;
        } else {
            StockKeepingUnit entity = new StockKeepingUnit();
//            entity.setSkuId(dto.getSkuId());
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