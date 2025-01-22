package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.PackDto;
import com.fptgang.backend.model.Pack;
import com.fptgang.backend.repository.PackRepos;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class PackMapper extends BaseMapper<PackDto, Pack> {

    @Autowired
    private PackRepos packRepos;
    @Autowired
    private BlindBoxMapper blindBoxMapper;

    @Override
    public Pack toEntity(PackDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Pack> existingPackOptional = packRepos.findById(dto.getPackId());

        if (existingPackOptional.isPresent()) {
            Pack existingPack = existingPackOptional.get();
            existingPack.setName(dto.getName() != null ? dto.getName() : existingPack.getName());
            existingPack.setDescription(dto.getDescription() != null ? dto.getDescription() : existingPack.getDescription());
            existingPack.setQuantity(dto.getQuantity() != null ? dto.getQuantity() : existingPack.getQuantity());
            existingPack.setPrice(dto.getPrice() != null ? dto.getPrice() : existingPack.getPrice());
            existingPack.setVisible( dto.getIsVisible() != null ? dto.getIsVisible() : existingPack.isVisible());

            return existingPack;
        } else {
            Pack entity = new Pack();
            entity.setPackId(dto.getPackId());
            entity.setName(dto.getName());
            entity.setDescription(dto.getDescription());
            entity.setQuantity(dto.getQuantity());
            entity.setPrice(dto.getPrice());
            entity.setVisible( dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());

            return entity;
        }
    }

    @Override
    public PackDto toDTO(Pack entity) {
        if (entity == null) {
            return null;
        }

        PackDto dto = new PackDto();
        dto.setPackId(entity.getPackId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setQuantity(entity.getQuantity());
        dto.setPrice(entity.getPrice());
        dto.setBlindBoxes(entity.getBlindBoxes().stream().map(blindBoxMapper::toDTO).toList());
            dto.setIsVisible(entity.isVisible());
        // Set other fields similarly

        return dto;
    }
}