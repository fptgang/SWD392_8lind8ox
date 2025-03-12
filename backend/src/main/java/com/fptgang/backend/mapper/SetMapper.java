package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.SetDto;
import com.fptgang.backend.model.Set;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.StockKeepingUnitRepos;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Component
public class SetMapper extends BaseMapper<SetDto, Set> {
    private StockKeepingUnitRepos stockKeepingUnitRepos;
    private BlindBoxRepos blindBoxRepos;
    private SlotMapper slotMapper;
    private StockKeepingUnitMapper stockKeepingUnitMapper;
    private BlindBoxMapper blindBoxMapper;

    public SetMapper(StockKeepingUnitRepos stockKeepingUnitRepos,
                     BlindBoxRepos blindBoxRepos,
                     SlotMapper slotMapper,
                     StockKeepingUnitMapper stockKeepingUnitMapper,
                     BlindBoxMapper blindBoxMapper) {
        this.stockKeepingUnitRepos = stockKeepingUnitRepos;
        this.blindBoxRepos = blindBoxRepos;
        this.slotMapper = slotMapper;
        this.stockKeepingUnitMapper = stockKeepingUnitMapper;
        this.blindBoxMapper = blindBoxMapper;
    }

    @Override
    public Set toEntity(SetDto dto) {
        if (dto == null) {
            return null;
        }

        Set entity = new Set();
        entity.setSetId(dto.getSetId());
        if (dto.getSku() != null) {
            entity.setSku(stockKeepingUnitRepos.getReferenceById(dto.getSku().getSkuId()));
        }
        entity.setIsVisible(dto.getIsVisible());
        if (dto.getSlots() != null) {
            entity.setSlots(dto.getSlots().stream()
                    .map(slotMapper::toEntity)
                    .collect(Collectors.toList()));
        }
        if (dto.getBlindBox() != null) {
            entity.setBlindBox(blindBoxRepos.getReferenceById(dto.getBlindBox().getBlindBoxId()));
        }
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        return entity;
    }

    @Override
    public SetDto toDTO(Set entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        SetDto dto = new SetDto();
        dto.setSetId(entity.getSetId());
        dto.setIsVisible(entity.getIsVisible());

        if (level == DetailLevel.REFERENCE) {
            return dto; // those fields are enough
        }

        dto.setBlindBox(blindBoxMapper.toDTO(entity.getBlindBox(), DetailLevel.REFERENCE));
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        dto.setSku(stockKeepingUnitMapper.toDTO(entity.getSku(), DetailLevel.REFERENCE));
        if (entity.getSlots() != null) {
            dto.setSlots(entity.getSlots().stream()
                    .map(e -> slotMapper.toDTO(e, DetailLevel.REFERENCE))
                    .collect(Collectors.toList()));
        }
        return dto;
    }
}