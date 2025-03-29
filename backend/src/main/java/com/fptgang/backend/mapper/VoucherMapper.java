package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.VoucherDto;
import com.fptgang.backend.model.Voucher;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class VoucherMapper extends BaseMapper<VoucherDto, Voucher> {
    private final OrderRepos orderRepos;
    private final AccountRepos accountRepos;
    private final AccountMapper accountMapper;

    public VoucherMapper(OrderRepos orderRepos,
                         AccountRepos accountRepos,
                         AccountMapper accountMapper) {
        this.orderRepos = orderRepos;
        this.accountRepos = accountRepos;
        this.accountMapper = accountMapper;
    }

    @Override
    public Voucher toEntity(VoucherDto dto) {
        if (dto == null) {
            return null;
        }

        Voucher entity = new Voucher();
        entity.setVoucherId(dto.getVoucherId());
        if (dto.getOrderId() != null) {
            entity.setOrder(orderRepos.getReferenceById(dto.getOrderId()));
        }
        entity.setAccount(accountRepos.getReferenceById(dto.getAccount().getAccountId()));
        entity.setCode(dto.getCode());
        entity.setDiscountRate(dto.getDiscountRate());
        entity.setLimitAmount(dto.getLimitAmount());
        if(dto.getState() != null) {
            entity.setState(Voucher.State.valueOf(dto.getState().name()));
        }
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        entity.setExpiredAt(DateTimeUtil.fromOffsetToLocal(dto.getExpiredAt()));
        return entity;
    }

    @Override
    public VoucherDto toDTO(Voucher entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        VoucherDto dto = new VoucherDto();
        dto.setVoucherId(entity.getVoucherId());
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setAccount(accountMapper.toDTO(entity.getAccount(), DetailLevel.REFERENCE));
        dto.setCode(entity.getCode());
        dto.setDiscountRate(entity.getDiscountRate());
        dto.setLimitAmount(entity.getLimitAmount());
        dto.setState(VoucherDto.StateEnum.valueOf(entity.getState().name()));
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        dto.setExpiredAt(DateTimeUtil.fromLocalToOffset(entity.getExpiredAt()));
        return dto;
    }
}