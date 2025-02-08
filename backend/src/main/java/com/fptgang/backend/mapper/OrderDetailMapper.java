package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.OrderDetailDto;
import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.repository.*;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class OrderDetailMapper extends BaseMapper<OrderDetailDto, OrderDetail> {

    @Autowired
    private OrderDetailRepos orderDetailRepos;
    @Autowired
    private OrderRepos orderRepos;
    @Autowired
    private StockKeepingUnitRepos skuRepos;
    @Autowired
    private PromotionalCampaignRepos promotionalCampaignRepos;
    @Autowired
    private SlotRepos slotRepos;

    @Override
    public OrderDetail toEntity(OrderDetailDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<OrderDetail> existingOrderDetailOptional = orderDetailRepos.findById(dto.getOrderDetailId());

        if (existingOrderDetailOptional.isPresent()) {
            OrderDetail existingOrderDetail = existingOrderDetailOptional.get();
            existingOrderDetail.setCheckoutPrice(dto.getDiscountPrice() != null ? dto.getDiscountPrice() : existingOrderDetail.getCheckoutPrice());
            existingOrderDetail.setOriginalPrice(dto.getOriginalProductPrice() != null ? dto.getOriginalProductPrice() : existingOrderDetail.getOriginalPrice());
            if (dto.getOrderId() != null) {
                existingOrderDetail.setOrder(orderRepos.findById(dto.getOrderId()).orElse(null));
            }
            if (dto.getSkuId() != null) {
                existingOrderDetail.setStockKeepingUnit(skuRepos.findById(dto.getSkuId()).orElse(null));
            }
            if (dto.getPromotionalCampaignId() != null) {
                existingOrderDetail.setPromotionalCampaign(promotionalCampaignRepos.findById(dto.getPromotionalCampaignId()).orElse(null));
            }
            if (dto.getSlotId() != null) {
                existingOrderDetail.setSlot(slotRepos.findById(dto.getSlotId()).orElse(null));
            }
            return existingOrderDetail;
        } else {
            OrderDetail entity = new OrderDetail();
            entity.setOrderDetailId(dto.getOrderDetailId());
            entity.setCheckoutPrice(dto.getDiscountPrice() != null ? dto.getDiscountPrice() : entity.getCheckoutPrice());
            entity.setOriginalPrice(dto.getOriginalProductPrice() != null ? dto.getOriginalProductPrice() : entity.getOriginalPrice());
            if (dto.getOrderId() != null) {
                entity.setOrder(orderRepos.findById(dto.getOrderId()).orElse(null));
            }
            if (dto.getSkuId() != null) {
                entity.setStockKeepingUnit(skuRepos.findById(dto.getSkuId()).orElse(null));
            }
            if (dto.getPromotionalCampaignId() != null) {
                entity.setPromotionalCampaign(promotionalCampaignRepos.findById(dto.getPromotionalCampaignId()).orElse(null));
            }
            if (dto.getSlotId() != null) {
                entity.setSlot(slotRepos.findById(dto.getSlotId()).orElse(null));
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
    public OrderDetailDto toDTO(OrderDetail entity) {
        if (entity == null) {
            return null;
        }

        OrderDetailDto dto = new OrderDetailDto();
        dto.setOrderDetailId(entity.getOrderDetailId());
        dto.setDiscountPrice(entity.getCheckoutPrice());
        dto.setOriginalProductPrice(entity.getOriginalPrice());
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setSkuId(entity.getStockKeepingUnit() != null ? entity.getStockKeepingUnit().getSkuId() : null);
        dto.setPromotionalCampaignId(entity.getPromotionalCampaign() != null ? entity.getPromotionalCampaign().getCampaignId() : null);
        dto.setSlotId(entity.getSlot() != null ? entity.getSlot().getSlotId() : null);
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        return dto;
    }
}