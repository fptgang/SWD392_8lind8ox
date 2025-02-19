package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.ToyDto;
import com.fptgang.backend.model.Toy;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.repository.ToyRepos;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Slf4j
@Component
public class ToyMapper extends BaseMapper<ToyDto, Toy> {

    @Autowired
    private ToyRepos toyRepos;
    @Autowired
    private BlindBoxRepos blindBoxRepos;

    @Override
    public Toy toEntity(ToyDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Toy> existingToyOptional = toyRepos.findById(dto.getToyId() == null ? 0 : dto.getToyId());

        if (existingToyOptional.isPresent() && dto.getToyId() != null) {
            Toy existingToy = existingToyOptional.get();
            existingToy.setName(dto.getName() != null ? dto.getName() : existingToy.getName());
            existingToy.setDescription(dto.getDescription() != null ? dto.getDescription() : existingToy.getDescription());
            existingToy.setRarity(dto.getRarity() != null ? Toy.Rarity.valueOf(dto.getRarity().name()) : existingToy.getRarity());
            existingToy.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingToy.isVisible());
            existingToy.setWeight(dto.getWeight() != null ? dto.getWeight() : existingToy.getWeight());
            if(dto.getBlindBoxId()!=null){
                existingToy.setBlindBox(blindBoxRepos.getReferenceById(dto.getBlindBoxId()));
            }
            return existingToy;
        } else {
            Toy entity = new Toy();
//            entity.setToyId(dto.getToyId());
            entity.setName(dto.getName());
            entity.setDescription(dto.getDescription());
            entity.setRarity(Toy.Rarity.valueOf(dto.getRarity().name()));
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
            entity.setWeight(dto.getWeight());
            if (dto.getCreatedAt() != null) {
                entity.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
            }
            if (dto.getUpdatedAt() != null) {
                entity.setUpdatedAt(dto.getUpdatedAt().toLocalDateTime());
            }
            if(dto.getBlindBoxId()!=null){
                entity.setBlindBox(blindBoxRepos.getReferenceById(dto.getBlindBoxId()));
            }
            return entity;
        }
    }

    @Override
    public ToyDto toDTO(Toy entity) {
        if (entity == null) {
            return null;
        }

        ToyDto dto = new ToyDto();
        dto.setToyId(entity.getToyId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setRarity(ToyDto.RarityEnum.valueOf(entity.getRarity().name()));
        dto.setIsVisible(entity.isVisible());
        dto.setWeight(entity.getWeight());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        dto.setBlindBoxId(entity.getBlindBox().getBlindBoxId());
        return dto;
    }
}