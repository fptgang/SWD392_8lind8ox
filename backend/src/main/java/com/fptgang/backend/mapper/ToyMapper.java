package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.ToyDto;
import com.fptgang.backend.model.Toy;
import com.fptgang.backend.repository.ImageRepos;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Slf4j
@Component
public class ToyMapper extends BaseMapper<ToyDto, Toy> {
    private final ImageRepos imageRepos;
    private final ImageMapper imageMapper;

    public ToyMapper(ImageRepos imageRepos, ImageMapper imageMapper) {
        this.imageRepos = imageRepos;
        this.imageMapper = imageMapper;
    }

    @Override
    public Toy toEntity(ToyDto dto) {
        if (dto == null) {
            return null;
        }

        Toy entity = new Toy();
        entity.setToyId(dto.getToyId());
        entity.setName(dto.getName());
        entity.setDescription(dto.getDescription());
        entity.setWeight(dto.getWeight());
        entity.setRarity(Toy.Rarity.valueOf(dto.getRarity().name()));
        entity.setIsVisible(dto.getIsVisible());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        if (dto.getImages() != null) {
            entity.setImages(dto.getImages().stream()
                    .map(e -> imageRepos.getReferenceById(e.getImageId()))
                    .collect(Collectors.toList()));
        }
        return entity;
    }

    @Override
    public ToyDto toDTO(Toy entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        ToyDto dto = new ToyDto();
        dto.setToyId(entity.getToyId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setWeight(entity.getWeight());
        dto.setRarity(ToyDto.RarityEnum.valueOf(entity.getRarity().name()));
        dto.setIsVisible(entity.getIsVisible());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        if (entity.getImages() != null) {
            dto.setImages(entity.getImages().stream()
                    .map(e -> imageMapper.toDTO(e, DetailLevel.REFERENCE))
                    .collect(Collectors.toList()));
        }
        return dto;
    }
}