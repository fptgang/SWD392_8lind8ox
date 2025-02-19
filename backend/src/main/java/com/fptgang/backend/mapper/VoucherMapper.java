package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.VoucherDto;
import com.fptgang.backend.model.Voucher;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.repository.VoucherRepos; // Assume this repository exists
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class VoucherMapper extends BaseMapper<VoucherDto, Voucher> {

    @Autowired
    private VoucherRepos voucherRepos;
    @Autowired
    private AccountRepos accountRepos;
    @Autowired
    private OrderRepos orderRepos;

    @Override
    public Voucher toEntity(VoucherDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Voucher> existing = voucherRepos.findById(
                dto.getVoucherId() == null ? 0 : dto.getVoucherId()
        );

        if (existing.isPresent() && dto.getVoucherId() != null) {
            Voucher entity = existing.get();
            if (dto.getCode() != null) {
                entity.setCode(dto.getCode());
            }
            if (dto.getDiscountRate() != null) {
                entity.setDiscountRate(dto.getDiscountRate());
            }
            if (dto.getLimitAmount() != null) {
                entity.setLimitAmount(dto.getLimitAmount());
            }
            if (dto.getIsUsed() != null) {
                entity.setUsed(dto.getIsUsed());
            }
            if(dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).orElse(null));
            }
            if(dto.getOrderId() != null) {
                entity.setOrder(orderRepos.findById(dto.getOrderId()).orElse(null));
            }
            // entity.setOrder(...) & entity.setAccount(...)
            // if you need to handle these relationships
            // Do not modify createdAt if already set
            if (dto.getExpiredAt() != null) {
                entity.setExpiredAt(DateTimeUtil.fromOffsetToLocal(dto.getExpiredAt()));
            }
            return entity;
        } else {
            Voucher entity = new Voucher();
            entity.setCode(dto.getCode());
            entity.setDiscountRate(dto.getDiscountRate());
            entity.setLimitAmount(dto.getLimitAmount());
            entity.setUsed(dto.getIsUsed() != null && dto.getIsUsed());
            if(dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).orElse(null));
            }
            // entity.setOrder(...) & entity.setAccount(...) if needed
            if (dto.getExpiredAt() != null) {
                entity.setExpiredAt(DateTimeUtil.fromOffsetToLocal(dto.getExpiredAt()));
            }
            return entity;
        }
    }

    @Override
    public VoucherDto toDTO(Voucher entity) {
        if (entity == null) {
            return null;
        }

        VoucherDto dto = new VoucherDto();
        dto.setVoucherId(entity.getVoucherId());
        if (entity.getOrder() != null) {
            dto.setOrderId(entity.getOrder().getOrderId());
        }
        if (entity.getAccount() != null) {
            dto.setAccountId(entity.getAccount().getAccountId());
        }
        dto.setCode(entity.getCode());
        dto.setDiscountRate(entity.getDiscountRate());
        dto.setLimitAmount(entity.getLimitAmount());
        dto.setIsUsed(entity.isUsed());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setExpiredAt(DateTimeUtil.fromLocalToOffset(entity.getExpiredAt()));
        return dto;
    }
}