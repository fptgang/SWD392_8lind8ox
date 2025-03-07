package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.SlotDto;
import com.fptgang.backend.model.Slot;
import com.fptgang.backend.repository.SetRepos;
import com.fptgang.backend.repository.ToyRepos;
import com.fptgang.backend.repository.VideoRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class SlotMapper extends BaseMapper<SlotDto, Slot> {
    private final ToyRepos toyRepos;
    private final SetRepos setRepos;
    private final VideoRepos videoRepos;
    private final ToyMapper toyMapper;
    private final VideoMapper videoMapper;

    public SlotMapper(ToyRepos toyRepos,
                      SetRepos setRepos,
                      VideoRepos videoRepos,
                      ToyMapper toyMapper,
                      VideoMapper videoMapper) {
        this.toyRepos = toyRepos;
        this.setRepos = setRepos;
        this.videoRepos = videoRepos;
        this.toyMapper = toyMapper;
        this.videoMapper = videoMapper;
    }

    @Override
    public Slot toEntity(SlotDto dto) {
        if (dto == null) {
            return null;
        }

        Slot entity = new Slot();
        entity.setSlotId(dto.getSlotId());
        entity.setPosition(dto.getPosition());
        entity.setState(Slot.State.valueOf(dto.getState().name()));
        entity.setIsVisible(dto.getIsVisible());
        entity.setOpenedAt(DateTimeUtil.fromOffsetToLocal(dto.getOpenedAt()));
        if (dto.getToy() != null) {
            entity.setToy(toyRepos.getReferenceById(dto.getToy().getToyId()));
        }
        if (dto.getSetId() != null) {
            entity.setSet(setRepos.getReferenceById(dto.getSetId()));
        }
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        if (dto.getVideo() != null) {
            entity.setVideo(videoRepos.getReferenceById(dto.getVideo().getVideoId()));
        }
        return entity;
    }

    @Override
    public SlotDto toDTO(Slot entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        SlotDto dto = new SlotDto();
        dto.setSlotId(entity.getSlotId());
        dto.setPosition(entity.getPosition());
        dto.setState(SlotDto.StateEnum.valueOf(entity.getState().name()));
        dto.setIsVisible(entity.getIsVisible());
        dto.setOpenedAt(DateTimeUtil.fromLocalToOffset(entity.getOpenedAt()));
        dto.setToy(toyMapper.toDTO(entity.getToy(), DetailLevel.REFERENCE));
        if (entity.getSet() != null) {
            dto.setSetId(entity.getSet().getSetId());
        }
        dto.setVideo(videoMapper.toDTO(entity.getVideo(), DetailLevel.REFERENCE));
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        return dto;
    }
}