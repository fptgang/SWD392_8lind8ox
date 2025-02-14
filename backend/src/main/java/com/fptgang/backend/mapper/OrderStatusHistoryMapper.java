package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.OrderStatusHistoryDto;
import com.fptgang.backend.model.OrderStatusHistory;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.repository.OrderStatusHistoryRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class OrderStatusHistoryMapper extends BaseMapper<OrderStatusHistoryDto, OrderStatusHistory> {

    @Autowired
    private OrderRepos orderRepos;
    @Autowired
    private AccountRepos accountRepos;
    @Autowired
    private OrderStatusHistoryRepos orderStatusHistoryRepos;

    @Override
    public OrderStatusHistory toEntity(OrderStatusHistoryDto dto) {
        if (dto == null) {
            return null;
        }
        Optional<OrderStatusHistory> existingOrderStatusHistoryOptional = orderStatusHistoryRepos.findById(dto.getId() == null ? 0 : dto.getId());
        if (existingOrderStatusHistoryOptional.isPresent() && dto.getId() != null) {
            OrderStatusHistory existingOrderStatusHistory = existingOrderStatusHistoryOptional.get();
            existingOrderStatusHistory.setState(OrderStatusHistory.State.valueOf(dto.getState().name()));
            if (dto.getOrderId() != null) {
                existingOrderStatusHistory.setOrder(orderRepos.findById(dto.getOrderId()).orElse(null));
            }
            if (dto.getAccountId() != null) {
                existingOrderStatusHistory.setCreator(accountRepos.findById(dto.getAccountId()).orElse(null));
            }
            if (dto.getCreatedAt() != null) {
                existingOrderStatusHistory.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
            }
            return existingOrderStatusHistory;
        } else {
            OrderStatusHistory entity = new OrderStatusHistory();
            entity.setState(OrderStatusHistory.State.valueOf(dto.getState().name()));
            if (dto.getOrderId() != null) {
                entity.setOrder(orderRepos.findById(dto.getOrderId()).orElse(null));
            }
            if (dto.getAccountId() != null) {
                entity.setCreator(accountRepos.findById(dto.getAccountId()).orElse(null));
            }
            if (dto.getCreatedAt() != null) {
                entity.setCreatedAt(dto.getCreatedAt().toLocalDateTime());
            }
            return entity;
        }
    }

    @Override
    public OrderStatusHistoryDto toDTO(OrderStatusHistory entity) {
        if (entity == null) {
            return null;
        }

        OrderStatusHistoryDto dto = new OrderStatusHistoryDto();
        dto.setId(entity.getId());
        dto.setState(OrderStatusHistoryDto.StateEnum.valueOf(entity.getState().name()));
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setAccountId(entity.getCreator() != null ? entity.getCreator().getAccountId() : null);
        if (entity.getCreatedAt() != null) {
            dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        }
        return dto;
    }
}