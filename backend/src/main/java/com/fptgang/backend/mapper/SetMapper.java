package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.SetDto;
import com.fptgang.backend.model.Set;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.SetRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class SetMapper extends BaseMapper<SetDto, Set> {

    @Autowired
    private SetRepos setRepos;
    @Autowired
    private BlindBoxRepos blindBoxRepos;
    @Autowired
    private SlotMapper slotMapper;
    @Autowired
    private ImageMapper imageMapper;
    @Autowired
    private BlindBoxMapper blindBoxMapper;

    @Override
    public Set toEntity(SetDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Set> existingSetOptional = setRepos.findById(dto.getSetId());

        if (existingSetOptional.isPresent()) {
            Set existingSet = existingSetOptional.get();
            existingSet.setCurrentPrice(dto.getCurrentPrice() != null ? dto.getCurrentPrice() : existingSet.getCurrentPrice());
            existingSet.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingSet.isVisible());
            if (dto.getImageIds() != null) {
                existingSet.setImages(dto.getImageIds().stream().map(imageMapper::toEntity).collect(Collectors.toList()));
            }
            if (dto.getSlots() != null) {
                existingSet.setSlots(dto.getSlots().stream().map(slotMapper::toEntity).collect(Collectors.toList()));
            }
            existingSet.setBlindBox(dto.getBlindBox() != null
                    && dto.getBlindBox().getBlindBoxId() != existingSet.getBlindBox().getBlindBoxId() ?
                    blindBoxRepos.findById(dto.getBlindBox().getBlindBoxId()).get()
                    : existingSet.getBlindBox());
            return existingSet;
        } else {
            Set entity = new Set();
            entity.setSetId(dto.getSetId());
            entity.setCurrentPrice(dto.getCurrentPrice());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            entity.setBlindBox(dto.getBlindBox() != null ?
                    blindBoxRepos.findById(dto.getBlindBox().getBlindBoxId()).get()
                    : null);
            if (dto.getCreatedAt() != null) {
                entity.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
            }
            if (dto.getUpdatedAt() != null) {
                entity.setUpdatedAt(dto.getUpdatedAt().toLocalDateTime());
            }
            if (dto.getImageIds() != null) {
                entity.setImages(dto.getImageIds().stream().map(imageMapper::toEntity).collect(Collectors.toList()));
            }
            if (dto.getSlots() != null) {
                entity.setSlots(dto.getSlots().stream().map(slotMapper::toEntity).collect(Collectors.toList()));
            }
            return entity;
        }
    }

    @Override
    public SetDto toDTO(Set entity) {
        if (entity == null) {
            return null;
        }

        SetDto dto = new SetDto();
        dto.setSetId(entity.getSetId());
        dto.setCurrentPrice(entity.getCurrentPrice());
        dto.setIsVisible(entity.isVisible());
        if (entity.getBlindBox() != null) {
            dto.setBlindBox(blindBoxMapper.toDTO(entity.getBlindBox()));
        }
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        if (entity.getImages() != null) {
            dto.setImageIds(entity.getImages().stream().map(imageMapper::toDTO).collect(Collectors.toList()));
        }
        if (entity.getSlots() != null) {
            dto.setSlots(entity.getSlots().stream().map(slotMapper::toDTO).collect(Collectors.toList()));
        }
        return dto;
    }
}