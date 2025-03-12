package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.OrderDto;
import com.fptgang.backend.api.model.OrderStatus;
import com.fptgang.backend.model.Order;
import com.fptgang.backend.model.OrderStatusHistory;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Component
public class OrderMapper extends BaseMapper<OrderDto, Order> {

    private final AccountRepos accountRepos;
    private final AccountMapper accountMapper;
    private final OrderStatusHistoryMapper orderStatusHistoryMapper;
    private final OrderDetailMapper orderDetailMapper;
    private final TransactionMapper transactionMapper;
    private final VoucherMapper voucherMapper;
    private final ShippingInfoMapper shippingInfoMapper;

    public OrderMapper(AccountRepos accountRepos,
                       AccountMapper accountMapper,
                       OrderStatusHistoryMapper orderStatusHistoryMapper,
                       OrderDetailMapper orderDetailMapper,
                       TransactionMapper transactionMapper,
                       VoucherMapper voucherMapper,
                       ShippingInfoMapper shippingInfoMapper) {
        this.accountRepos = accountRepos;
        this.accountMapper = accountMapper;
        this.orderStatusHistoryMapper = orderStatusHistoryMapper;
        this.orderDetailMapper = orderDetailMapper;
        this.transactionMapper = transactionMapper;
        this.voucherMapper = voucherMapper;
        this.shippingInfoMapper = shippingInfoMapper;
    }

    @Override
    public Order toEntity(OrderDto dto) {
        if (dto == null) {
            return null;
        }

        Order entity = new Order();
        entity.setOrderId(dto.getOrderId());
        entity.setAccount(accountRepos.getReferenceById(dto.getAccount().getAccountId()));
        if (dto.getOrderStatusHistories() != null) {
            entity.setOrderStatusHistories(dto.getOrderStatusHistories().stream()
                    .map(orderStatusHistoryMapper::toEntity)
                    .collect(Collectors.toList()));
        }
        if (dto.getLatestStatus() != null) {
            entity.setLatestStatus(OrderStatusHistory.State.valueOf(dto.getLatestStatus().name()));
        }
        if (dto.getOrderDetails() != null) {
            entity.setOrderDetails(dto.getOrderDetails().stream()
                    .map(orderDetailMapper::toEntity)
                    .collect(Collectors.toList()));
        }
        if (dto.getTransaction() != null) {
            entity.setTransaction(transactionMapper.toEntity(dto.getTransaction()));
        }
        if(dto.getVoucher() != null) {
            entity.setVoucher(voucherMapper.toEntity(dto.getVoucher()));
        }
        if(dto.getShippingInfo() != null) {
            entity.setShippingInfo(shippingInfoMapper.toEntity(dto.getShippingInfo()));
        }
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        entity.setSubTotal(dto.getSubTotal());
        entity.setFinalTotal(dto.getFinalTotal());
        return entity;
    }

    @Override
    public OrderDto toDTO(Order entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        OrderDto dto = new OrderDto();
        dto.setOrderId(entity.getOrderId());
        if (level == DetailLevel.REFERENCE) {
            return dto; // those fields are enough
        }

        dto.setAccount(accountMapper.toDTO(entity.getAccount(), DetailLevel.REFERENCE));
        dto.setOrderStatusHistories(entity.getOrderStatusHistories().stream()
                .map(e -> orderStatusHistoryMapper.toDTO(e, DetailLevel.REFERENCE))
                .collect(Collectors.toList()));
        dto.setSubTotal(entity.getSubTotal());
        dto.setFinalTotal(entity.getFinalTotal());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));

        if (level == DetailLevel.SUMMARY) {
            return dto; // those fields are enough
        }

        dto.setOrderDetails(entity.getOrderDetails().stream()
                .map(e -> orderDetailMapper.toDTO(e, DetailLevel.REFERENCE))
                .collect(Collectors.toList()));
        dto.setLatestStatus(OrderStatus.valueOf(entity.getLatestStatus().name()));
        dto.setTransaction(transactionMapper.toDTO(entity.getTransaction(), DetailLevel.REFERENCE));
        dto.setVoucher(voucherMapper.toDTO(entity.getVoucher(), DetailLevel.REFERENCE));
        dto.setShippingInfo(shippingInfoMapper.toDTO(entity.getShippingInfo(), DetailLevel.REFERENCE));
        return dto;
    }
}