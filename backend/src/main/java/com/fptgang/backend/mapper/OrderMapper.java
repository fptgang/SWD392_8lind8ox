package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.OrderDto;
import com.fptgang.backend.model.Order;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class OrderMapper extends BaseMapper<OrderDto, Order> {

    @Autowired
    private OrderRepos orderRepos;
    @Autowired
    private AccountRepos accountRepos;
    @Autowired
    private OrderDetailMapper orderDetailMapper;
    @Autowired
    private OrderStatusHistoryMapper orderStatusHistoryMapper;

    @Override
    public Order toEntity(OrderDto dto) {
        if (dto == null) {
            return null;
        }


        Optional<Order> existingOrderOptional = orderRepos.findById(dto.getOrderId() == null ? 0 : dto.getOrderId());

        if (existingOrderOptional.isPresent() && dto.getOrderId() != null) {
            Order existingOrder = existingOrderOptional.get();
//            existingOrder.setTotalPrice(dto.getTotalPrice() != null ? dto.getTotalPrice() : existingOrder.getTotalPrice());
            if (dto.getOrderDetails() != null) {
                existingOrder.setOrderDetails(dto.getOrderDetails().stream().map(orderDetailMapper::toEntity).collect(Collectors.toList()));
            }
            if (dto.getOrderStatusHistories() != null) {
                existingOrder.setOrderStatusHistories(dto.getOrderStatusHistories().stream().map(orderStatusHistoryMapper::toEntity).collect(Collectors.toList()));
            }
            return existingOrder;
        } else {
            Order entity = new Order();
//            entity.setOrderId(dto.getOrderId());
//            entity.setTotalPrice(dto.getTotalPrice());
            if (dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).orElse(null));
            }
            if (dto.getOrderDetails() != null) {
                entity.setOrderDetails(dto.getOrderDetails().stream().map(orderDetailMapper::toEntity).collect(Collectors.toList()));
            }
            if (dto.getOrderStatusHistories() != null) {
                entity.setOrderStatusHistories(dto.getOrderStatusHistories().stream().map(orderStatusHistoryMapper::toEntity).collect(Collectors.toList()));
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
    public OrderDto toDTO(Order entity) {
        if (entity == null) {
            return null;
        }

        OrderDto dto = new OrderDto();
        dto.setOrderId(entity.getOrderId());
//        dto.setTotalPrice(entity.getTotalPrice());
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
        dto.setOrderDetails(entity.getOrderDetails().stream().map(orderDetailMapper::toDTO).collect(Collectors.toList()));
        dto.setOrderStatusHistories(entity.getOrderStatusHistories().stream().map(orderStatusHistoryMapper::toDTO).collect(Collectors.toList()));
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        if (entity.getUpdatedAt() != null) {
            dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        }
        return dto;
    }
}