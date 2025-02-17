package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.ShippingInfoDto;
import com.fptgang.backend.model.ShippingInfo;
import com.fptgang.backend.repository.ShippingInfoRepos; // Example repository
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class ShippingInfoMapper extends BaseMapper<ShippingInfoDto, ShippingInfo> {

    @Autowired
    private ShippingInfoRepos shippingInfoRepos; // Assume this exists

    @Override
    public ShippingInfo toEntity(ShippingInfoDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<ShippingInfo> existing = shippingInfoRepos.findById(
                dto.getShippingInfoId() == null ? 0 : dto.getShippingInfoId()
        );

        if (existing.isPresent() && dto.getShippingInfoId() != null) {
            ShippingInfo entity = existing.get();
            if (dto.getAddress() != null) {
                entity.setAddress(dto.getAddress());
            }
            if (dto.getWard() != null) {
                entity.setWard(dto.getWard());
            }
            if (dto.getDistrict() != null) {
                entity.setDistrict(dto.getDistrict());
            }
            if (dto.getCity() != null) {
                entity.setCity(dto.getCity());
            }
            if (dto.getName() != null) {
                entity.setName(dto.getName());
            }
            if (dto.getPhoneNumber() != null) {
                entity.setPhoneNumber(dto.getPhoneNumber());
            }
            if (dto.getIsVisible() != null) {
                entity.setVisible(dto.getIsVisible());
            }
            // No changes to createdAt/updatedAt
            return entity;
        } else {
            ShippingInfo entity = new ShippingInfo();
            entity.setAddress(dto.getAddress());
            entity.setWard(dto.getWard());
            entity.setDistrict(dto.getDistrict());
            entity.setCity(dto.getCity());
            entity.setName(dto.getName());
            entity.setPhoneNumber(dto.getPhoneNumber());
            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : true);
            // Convert OffsetDateTime to LocalDateTime if needed
            return entity;
        }
    }

    @Override
    public ShippingInfoDto toDTO(ShippingInfo entity) {
        if (entity == null) {
            return null;
        }

        ShippingInfoDto dto = new ShippingInfoDto();
        dto.setShippingInfoId(entity.getShippingInfoId());
        dto.setAddress(entity.getAddress());
        dto.setWard(entity.getWard());
        dto.setDistrict(entity.getDistrict());
        dto.setCity(entity.getCity());
        dto.setName(entity.getName());
        dto.setPhoneNumber(entity.getPhoneNumber());
        dto.setIsVisible(entity.isVisible());
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        return dto;
    }
}