package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.PackageDto;
import com.fptgang.backend.model.Package;
import com.fptgang.backend.repository.PackageRepos;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class PackageMapper extends BaseMapper<PackageDto, Package> {

    @Autowired
    private PackageRepos packageRepos;
    @Autowired
    private BlindBoxMapper blindBoxMapper;

    @Override
    public Package toEntity(PackageDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Package> existingPackageOptional = packageRepos.findById(dto.getPackageId());

        if (existingPackageOptional.isPresent()) {
            Package existingPackage = existingPackageOptional.get();
            existingPackage.setName(dto.getName() != null ? dto.getName() : existingPackage.getName());
            existingPackage.setDescription(dto.getDescription() != null ? dto.getDescription() : existingPackage.getDescription());
            existingPackage.setQuantity(dto.getQuantity() != null ? dto.getQuantity() : existingPackage.getQuantity());
            existingPackage.setPrice(dto.getPrice() != null ? dto.getPrice() : existingPackage.getPrice());
            // Set other fields similarly

            return existingPackage;
        } else {
            Package entity = new Package();
            entity.setPackageId(dto.getPackageId());
            entity.setName(dto.getName());
            entity.setDescription(dto.getDescription());
            entity.setQuantity(dto.getQuantity());
            entity.setPrice(dto.getPrice());


            return entity;
        }
    }

    @Override
    public PackageDto toDTO(Package entity) {
        if (entity == null) {
            return null;
        }

        PackageDto dto = new PackageDto();
        dto.setPackageId(entity.getPackageId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setQuantity(entity.getQuantity());
        dto.setPrice(entity.getPrice());
        dto.setBlindBoxes(entity.getBlindBoxes().stream().map(blindBoxMapper::toDTO).toList());

        // Set other fields similarly

        return dto;
    }
}