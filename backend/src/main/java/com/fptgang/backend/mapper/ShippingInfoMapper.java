package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.ShippingInfoDto;
import com.fptgang.backend.model.ShippingInfo;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class ShippingInfoMapper extends BaseMapper<ShippingInfoDto, ShippingInfo> {

    @Override
    public ShippingInfo toEntity(ShippingInfoDto dto) {
        if (dto == null) {
            return null;
        }

        ShippingInfo entity = new ShippingInfo();
        if(dto.getShippingInfoId() != null && dto.getShippingInfoId() > 0) {
            entity.setShippingInfoId(dto.getShippingInfoId());
        }else {
            entity.setShippingInfoId(null);
        }
        entity.setAddress(dto.getAddress());
        entity.setWard(dto.getWard());
        entity.setDistrict(dto.getDistrict());
        entity.setCity(dto.getCity());
        entity.setName(dto.getName());
        entity.setPhoneNumber(dto.getPhoneNumber());
        entity.setIsVisible(dto.getIsVisible());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        return entity;
    }

    @Override
    public ShippingInfoDto toDTO(ShippingInfo entity, DetailLevel level) {
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
        dto.setIsVisible(entity.getIsVisible());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        return dto;
    }
}