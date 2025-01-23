package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.OrderDetailDto;
import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.repository.*;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class OrderDetailMapper extends BaseMapper<OrderDetailDto, OrderDetail> {

    @Autowired
    private OrderDetailRepos orderDetailRepos;
    @Autowired
    private OrderRepos orderRepos;
    @Autowired
    private ProductRepos productRepos;
    @Autowired
    private PackRepos packRepos;
    @Autowired
    private PromotionalCampaignRepos promotionalCampaignRepos;
    @Autowired
    private ToyMapper toyMapper;

    @Override
    public OrderDetail toEntity(OrderDetailDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<OrderDetail> existingOrderDetailOptional = orderDetailRepos.findById(dto.getOrderDetailId());

        if (existingOrderDetailOptional.isPresent()) {
            OrderDetail existingOrderDetail = existingOrderDetailOptional.get();
            existingOrderDetail.setDiscountPrice(dto.getDiscountPrice() != null ? dto.getDiscountPrice() : existingOrderDetail.getDiscountPrice());
            existingOrderDetail.setOriginalProductPrice(dto.getOriginalProductPrice() != null ? dto.getOriginalProductPrice() : existingOrderDetail.getOriginalProductPrice());
            existingOrderDetail.setRequestUnbox(dto.getRequestUnbox() != null ? dto.getRequestUnbox() : existingOrderDetail.isRequestUnbox());
            existingOrderDetail.setToyCount(dto.getToyCount());
            if(dto.getUnboxedToys()!=null){
                existingOrderDetail.setUnboxedToys(
                        dto.getUnboxedToys().stream().map(toyDto -> toyMapper.toEntity(toyDto)).collect(Collectors.toList())
                );
            }
            return existingOrderDetail;
        } else {
            OrderDetail entity = new OrderDetail();
            entity.setOrderDetailId(dto.getOrderDetailId());
            entity.setDiscountPrice(dto.getDiscountPrice() != null ? dto.getDiscountPrice() : entity.getDiscountPrice());
            entity.setOriginalProductPrice(dto.getOriginalProductPrice() != null ? dto.getOriginalProductPrice() : entity.getOriginalProductPrice());
            entity.setRequestUnbox(dto.getRequestUnbox());
            if(dto.getOrderId() != null) {
                entity.setOrder(orderRepos.findById(dto.getOrderId()).get());
            }
            if(dto.getProductId() != null) {
                entity.setProduct(productRepos.findById(dto.getProductId()).get());
            }
            if(dto.getPromotionalCampaignId() !=null){
                entity.setPromotionalCampaign(promotionalCampaignRepos.findById( dto.getPromotionalCampaignId()).get());
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
        dto.setDiscountPrice(entity.getDiscountPrice());
        dto.setOriginalProductPrice(entity.getOriginalProductPrice());
        dto.setRequestUnbox(entity.isRequestUnbox());
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setProductId(entity.getProduct() != null ? entity.getProduct().getProductId() : null);
        if(entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        return dto;
    }
}