//package com.fptgang.backend.mapper;
//
//import com.fptgang.backend.api.model.OrderDetailDto;
//import com.fptgang.backend.model.OrderDetail;
//import com.fptgang.backend.repository.BlindBoxRepos;
//import com.fptgang.backend.repository.OrderDetailRepos;
//import com.fptgang.backend.repository.OrderRepos;
//import com.fptgang.backend.repository.PackRepos;
//import com.fptgang.backend.util.DateTimeUtil;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import java.util.Optional;
//
//@Component
//public class OrderDetailMapper extends BaseMapper<OrderDetailDto, OrderDetail> {
//
//    @Autowired
//    private OrderDetailRepos orderDetailRepos;
//    @Autowired
//    private OrderRepos orderRepos;
//    @Autowired
//    private BlindBoxRepos blindBoxRepos;
//    @Autowired
//    private PackRepos packRepos;
//
//    @Override
//    public OrderDetail toEntity(OrderDetailDto dto) {
//        if (dto == null) {
//            return null;
//        }
//
//        Optional<OrderDetail> existingOrderDetailOptional = orderDetailRepos.findById(dto.getOrderDetailId());
//
//        if (existingOrderDetailOptional.isPresent()) {
//            OrderDetail existingOrderDetail = existingOrderDetailOptional.get();
//            existingOrderDetail.setPrice(dto.getPrice() != null ? dto.getPrice() : existingOrderDetail.getPrice());
//            existingOrderDetail.setRequestOpen(dto.getRequestOpen() != null ? dto.getRequestOpen() : existingOrderDetail.isRequestOpen());
//            existingOrderDetail.setReSell(dto.getReSell() != null ? dto.getReSell() : existingOrderDetail.isReSell());
//            existingOrderDetail.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingOrderDetail.isVisible());
//
//            return existingOrderDetail;
//        } else {
//            OrderDetail entity = new OrderDetail();
//            entity.setOrderDetailId(dto.getOrderDetailId());
//            entity.setPrice(dto.getPrice());
//            entity.setRequestOpen(dto.getRequestOpen());
//            entity.setReSell(dto.getReSell());
//            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
//            if(dto.getOrderId() != null) {
//                entity.setOrder(orderRepos.findById(dto.getOrderId()).get());
//            }
//            if(dto.getBlindBoxId() != null) {
//                entity.setBlindBox(blindBoxRepos.findById(dto.getBlindBoxId()).get());
//            }
//            if(dto.getPackId() != null) {
//                entity.setPack(packRepos.findById(dto.getPackId()).get());
//            }
//            if(dto.getCreatedDate() != null) {
//                entity.setCreatedDate(dto.getCreatedDate().toLocalDateTime());
//            }
//            return entity;
//        }
//    }
//
//    @Override
//    public OrderDetailDto toDTO(OrderDetail entity) {
//        if (entity == null) {
//            return null;
//        }
//
//        OrderDetailDto dto = new OrderDetailDto();
//        dto.setOrderDetailId(entity.getOrderDetailId());
//        dto.setPrice(entity.getPrice());
//        dto.setRequestOpen(entity.isRequestOpen());
//        dto.setReSell(entity.isReSell());
//        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
//        dto.setBlindBoxId(entity.getBlindBox() != null ? entity.getBlindBox().getBlindBoxId() : null);
//        dto.setPackId(entity.getPack() != null ? entity.getPack().getPackId() : null);
//        dto.setIsVisible(entity.isVisible());
//        if(entity.getCreatedDate() != null) {
//            dto.setCreatedDate(DateTimeUtil.fromLocalToOffset(entity.getCreatedDate()));
//        }
//        return dto;
//    }
//}