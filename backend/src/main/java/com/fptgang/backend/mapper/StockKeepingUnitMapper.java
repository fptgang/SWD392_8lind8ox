package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.StockKeepingUnitDto;
import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.repository.ImageRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class StockKeepingUnitMapper extends BaseMapper<StockKeepingUnitDto, StockKeepingUnit> {
    private final BlindBoxMapper blindBoxMapper;
    private final Converter delegate;

    public StockKeepingUnitMapper(BlindBoxMapper blindBoxMapper, Converter delegate) {
        this.blindBoxMapper = blindBoxMapper;
        this.delegate = delegate;
    }

    @Override
    public StockKeepingUnit toEntity(StockKeepingUnitDto dto) {
        StockKeepingUnit entity = delegate.toEntity(dto);

        if (entity != null) {
            entity.setBlindBox(blindBoxMapper.toEntity(dto.getBlindBox()));
        }

        return entity;
    }

    @Override
    public StockKeepingUnitDto toDTO(StockKeepingUnit entity, DetailLevel level) {
        StockKeepingUnitDto dto = delegate.toDTO(entity, level);

        if (dto != null) {
            dto.setBlindBox(blindBoxMapper.toDTO(entity.getBlindBox(), level));
        }

        return dto;
    }

    @Component
    public static class Converter extends BaseMapper<StockKeepingUnitDto, StockKeepingUnit> {
        private final ImageMapper imageMapper;
        private final ImageRepos imageRepos;

        public Converter(ImageMapper imageMapper, ImageRepos imageRepos) {
            this.imageMapper = imageMapper;
            this.imageRepos = imageRepos;
        }

        @Override
        public StockKeepingUnit toEntity(StockKeepingUnitDto dto) {
            if (dto == null) {
                return null;
            }

            StockKeepingUnit entity = new StockKeepingUnit();
            entity.setSkuId(dto.getSkuId());
            entity.setName(dto.getName());
            if (dto.getImage() != null) {
                entity.setImage(imageRepos.getReferenceById(dto.getImage().getImageId()));
            }
            entity.setPrice(dto.getPrice());
            entity.setStock(dto.getStock());
            entity.setSpecCount(dto.getSpecCount());
            entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
            entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
            entity.setIsVisible(dto.getIsVisible());
            return entity;
        }

        @Override
        public StockKeepingUnitDto toDTO(StockKeepingUnit entity, DetailLevel level) {
            if (entity == null) {
                return null;
            }

            StockKeepingUnitDto dto = new StockKeepingUnitDto();
            dto.setSkuId(entity.getSkuId());
            dto.setName(entity.getName());
            dto.setImage(imageMapper.toDTO(entity.getImage(), DetailLevel.REFERENCE));
            dto.setPrice(entity.getPrice());
            dto.setStock(entity.getStock());
            dto.setSpecCount(entity.getSpecCount());
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
            dto.setIsVisible(entity.getIsVisible());
            return dto;
        }
    }
}