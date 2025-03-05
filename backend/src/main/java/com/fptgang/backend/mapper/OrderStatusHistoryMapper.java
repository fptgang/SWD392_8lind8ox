package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.OrderStatusHistoryDto;
import com.fptgang.backend.model.OrderStatusHistory;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class OrderStatusHistoryMapper extends BaseMapper<OrderStatusHistoryDto, OrderStatusHistory> {

    private final OrderRepos orderRepos;

    public OrderStatusHistoryMapper(OrderRepos orderRepos) {
        this.orderRepos = orderRepos;
    }

    @Override
    public OrderStatusHistory toEntity(OrderStatusHistoryDto dto) {
        if (dto == null) {
            return null;
        }

        OrderStatusHistory entity = new OrderStatusHistory();
        entity.setId(dto.getId());
        if (dto.getOrderId() != null) {
            entity.setOrder(orderRepos.getReferenceById(dto.getOrderId()));
        }
        entity.setState(OrderStatusHistory.State.valueOf(dto.getState().name()));
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        return entity;
    }

    @Override
    public OrderStatusHistoryDto toDTO(OrderStatusHistory entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        OrderStatusHistoryDto dto = new OrderStatusHistoryDto();
        dto.setId(entity.getId());
        dto.setState(OrderStatusHistoryDto.StateEnum.valueOf(entity.getState().name()));
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        return dto;
    }
}