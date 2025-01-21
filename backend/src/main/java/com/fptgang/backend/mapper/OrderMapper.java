package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.OrderDto;
import com.fptgang.backend.model.Order;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.repository.TransactionRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class OrderMapper extends BaseMapper<OrderDto, Order> {

    @Autowired
    private OrderRepos orderRepos;
    @Autowired
    private AccountRepos accountRepos;
    @Autowired
    private TransactionRepos transactionRepos;
    @Autowired
    private OrderDetailMapper orderDetailMapper;

    @Override
    public Order toEntity(OrderDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Order> existingOrderOptional = orderRepos.findById(dto.getOrderId());

        if (existingOrderOptional.isPresent()) {
            Order existingOrder = existingOrderOptional.get();
            existingOrder.setOrderDate(DateTimeUtil.fromOffsetToLocal(dto.getOrderDate()));
            existingOrder.setOrderDate(dto.getOrderDate() != null ? DateTimeUtil.fromOffsetToLocal(dto.getOrderDate()) : existingOrder.getOrderDate());
            existingOrder.setTotalAmount(dto.getTotalAmount() != null ? dto.getTotalAmount() : existingOrder.getTotalAmount());
            existingOrder.setStatus(dto.getStatus() != null ? dto.getStatus() : existingOrder.getStatus());


            return existingOrder;
        } else {
            Order entity = new Order();
            entity.setOrderId(dto.getOrderId());
            entity.setTotalAmount(dto.getTotalAmount());
            entity.setStatus(dto.getStatus());
            if(dto.getOrderDate() != null) {
                entity.setOrderDate(DateTimeUtil.fromOffsetToLocal(dto.getOrderDate()));
            }
            if(dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).get());
            }
            if (dto.getTransactionId() != null) {
                entity.setTransaction(transactionRepos.findById(dto.getTransactionId()).get());
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
        dto.setOrderDate(DateTimeUtil.fromLocalToOffset(entity.getOrderDate()));
        dto.setTotalAmount(entity.getTotalAmount());
        dto.setStatus(entity.getStatus());
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
        dto.setTransactionId(entity.getTransaction() != null ? entity.getTransaction().getTransactionId() : null);
        dto.setOrderDetails(entity.getOrderDetails().stream().map(orderDetailMapper::toDTO).toList());

        return dto;
    }
}