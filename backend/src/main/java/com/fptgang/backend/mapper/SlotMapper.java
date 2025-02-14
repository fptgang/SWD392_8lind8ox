package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.SlotDto;
import com.fptgang.backend.model.Slot;
import com.fptgang.backend.repository.SetRepos;
import com.fptgang.backend.repository.SlotRepos;
import com.fptgang.backend.repository.ToyRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class SlotMapper extends BaseMapper<SlotDto, Slot> {

    @Autowired
    private SlotRepos slotRepos;
    @Autowired
    private SetRepos setRepos;
    @Autowired
    private ToyRepos toyRepos;

    @Override
    public Slot toEntity(SlotDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Slot> existingSlotOptional = slotRepos.findById(dto.getSlotId() == null ? 0 : dto.getSlotId());

        if (existingSlotOptional.isPresent() && dto.getSlotId() != null) {
            Slot existingSlot = existingSlotOptional.get();
            existingSlot.setPosition(dto.getPosition() != null ? dto.getPosition() : existingSlot.getPosition());
            existingSlot.setOpened(dto.getIsOpened() != null ? dto.getIsOpened() : existingSlot.isOpened());
            if (dto.getOpenedAt() != null) {
                existingSlot.setOpenedAt(dto.getOpenedAt().toLocalDateTime());
            }
            existingSlot.setToy(dto.getToyId() != null
                    && dto.getToyId() != existingSlot.getToy().getToyId() ?
                    toyRepos.findById(dto.getToyId()).get()
                    : existingSlot.getToy());
            existingSlot.setSet(dto.getSetId() != null
                    && dto.getSetId() != existingSlot.getSet().getSetId() ?
                    setRepos.findById(dto.getSetId()).get()
                    : existingSlot.getSet());
            return existingSlot;
        } else {
            Slot entity = new Slot();
            entity.setSlotId(dto.getSlotId());
            entity.setPosition(dto.getPosition());
            entity.setOpened(dto.getIsOpened() != null ? dto.getIsOpened() : entity.isOpened());
            entity.setToy(dto.getToyId() != null ?
                    toyRepos.findById(dto.getToyId()).get()
                    : null);
            entity.setSet(dto.getSetId() != null ?
                    setRepos.findById(dto.getSetId()).get()
                    : null);
            if (dto.getOpenedAt() != null) {
                entity.setOpenedAt(dto.getOpenedAt().toLocalDateTime());
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
    public SlotDto toDTO(Slot entity) {
        if (entity == null) {
            return null;
        }

        SlotDto dto = new SlotDto();
        dto.setSlotId(entity.getSlotId());
        dto.setPosition(entity.getPosition());
        dto.setIsOpened(entity.isOpened());
        dto.setToyId(entity.getToy() != null ? entity.getToy().getToyId() : null);
        dto.setSetId(entity.getSet() != null ? entity.getSet().getSetId() : null);
        if (entity.getOpenedAt() != null) {
            dto.setOpenedAt(DateTimeUtil.fromLocalToOffset(entity.getOpenedAt()));
        }
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        return dto;
    }
}