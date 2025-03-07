package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.TransactionDto;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class TransactionMapper extends BaseMapper<TransactionDto, Transaction> {
    private final AccountMapper accountMapper;
    private final AccountRepos accountRepos;
    private final OrderRepos orderRepos;

    public TransactionMapper(AccountMapper accountMapper,
                             AccountRepos accountRepos,
                             OrderRepos orderRepos) {
        this.accountMapper = accountMapper;
        this.accountRepos = accountRepos;
        this.orderRepos = orderRepos;
    }

    @Override
    public Transaction toEntity(TransactionDto dto) {
        if (dto == null) {
            return null;
        }

        Transaction entity = new Transaction();
        entity.setTransactionId(dto.getTransactionId());
        entity.setAccount(accountRepos.getReferenceById(dto.getAccount().getAccountId()));
        entity.setType(Transaction.Type.valueOf(dto.getType().getValue()));
        entity.setPaymentMethod(Transaction.PaymentMethod.valueOf(dto.getPaymentMethod().getValue()));
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        entity.setAmount(dto.getAmount());
        entity.setOldBalance(dto.getOldBalance());
        entity.setNewBalance(dto.getNewBalance());
        if (dto.getOrderId() != null) {
            entity.setOrder(orderRepos.getReferenceById(dto.getOrderId()));
        }
        entity.setStatus(Transaction.Status.valueOf(dto.getStatus().toString()));
        return entity;
    }

    @Override
    public TransactionDto toDTO(Transaction entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        TransactionDto dto = new TransactionDto();
        dto.setTransactionId(entity.getTransactionId());
        dto.setAccount(accountMapper.toDTO(entity.getAccount(), DetailLevel.REFERENCE));
        dto.setType(TransactionDto.TypeEnum.valueOf(entity.getType().toString()));
        dto.setPaymentMethod(TransactionDto.PaymentMethodEnum.valueOf(entity.getPaymentMethod().toString()));
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        dto.setAmount(entity.getAmount());
        dto.setOldBalance(entity.getOldBalance());
        dto.setNewBalance(entity.getNewBalance());
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setStatus(entity.getStatus() != null ? TransactionDto.StatusEnum.valueOf(entity.getStatus().toString()) : null);
        return dto;
    }
}