package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.OrderDetailDto;
import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.repository.PromotionalCampaignRepos;
import com.fptgang.backend.repository.SlotRepos;
import com.fptgang.backend.repository.StockKeepingUnitRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class OrderDetailMapper extends BaseMapper<OrderDetailDto, OrderDetail> {

    private final OrderRepos orderRepos;
    private final StockKeepingUnitRepos skuRepos;
    private final SlotRepos slotRepos;
    private final PromotionalCampaignRepos promotionalCampaignRepos;
    private final StockKeepingUnitMapper skuMapper;
    private final PromotionalCampaignMapper promotionalCampaignMapper;
    private final SlotMapper slotMapper;

    public OrderDetailMapper(OrderRepos orderRepos,
                             StockKeepingUnitRepos skuRepos,
                             SlotRepos slotRepos,
                             PromotionalCampaignRepos promotionalCampaignRepos,
                             StockKeepingUnitMapper skuMapper,
                             PromotionalCampaignMapper promotionalCampaignMapper,
                             SlotMapper slotMapper) {
        this.orderRepos = orderRepos;
        this.skuRepos = skuRepos;
        this.slotRepos = slotRepos;
        this.promotionalCampaignRepos = promotionalCampaignRepos;
        this.skuMapper = skuMapper;
        this.promotionalCampaignMapper = promotionalCampaignMapper;
        this.slotMapper = slotMapper;
    }

    @Override
    public OrderDetail toEntity(OrderDetailDto dto) {
        if (dto == null) {
            return null;
        }

        OrderDetail entity = new OrderDetail();
        entity.setOrderDetailId(dto.getOrderDetailId());
        if (dto.getOrderId() != null) {
            entity.setOrder(orderRepos.getReferenceById(dto.getOrderId()));
        }
        if (dto.getSku() != null) {
            entity.setStockKeepingUnit(skuRepos.getReferenceById(dto.getSku().getSkuId()));
        }
        entity.setQuantity(dto.getQuantity());
        if (dto.getPromotionalCampaign() != null) {
            entity.setPromotionalCampaign(promotionalCampaignRepos.getReferenceById(dto.getPromotionalCampaign().getCampaignId()));
        }
        entity.setOriginalPrice(dto.getOriginalPrice());
        entity.setCheckoutPrice(dto.getCheckoutPrice());
        if (dto.getSlot() != null) {
            entity.setSlot(slotRepos.getReferenceById(dto.getSlot().getSlotId()));
        }
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        return entity;
    }

    @Override
    public OrderDetailDto toDTO(OrderDetail entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        OrderDetailDto dto = new OrderDetailDto();
        dto.setOrderDetailId(entity.getOrderDetailId());
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setSku(skuMapper.toDTO(entity.getStockKeepingUnit(), DetailLevel.REFERENCE));
        dto.setQuantity(entity.getQuantity());
        dto.setPromotionalCampaign(promotionalCampaignMapper.toDTO(entity.getPromotionalCampaign(), DetailLevel.REFERENCE));
        dto.setOriginalPrice(entity.getOriginalPrice());
        dto.setCheckoutPrice(entity.getCheckoutPrice());
        dto.setSlot(slotMapper.toDTO(entity.getSlot(), DetailLevel.REFERENCE));
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        return dto;
    }
}