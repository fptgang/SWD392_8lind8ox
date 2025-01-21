package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.TransactionDto;
import com.fptgang.backend.model.Transaction;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.repository.TransactionRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class TransactionMapper extends BaseMapper<TransactionDto, Transaction> {

    @Autowired
    private TransactionRepos transactionRepos;
    @Autowired
    private AccountRepos accountRepos;
    @Autowired
    private OrderRepos orderRepos;

    @Override
    public Transaction toEntity(TransactionDto dto) {
        if (dto == null) {
            return null;
        }

        Optional<Transaction> existingTransactionOptional = transactionRepos.findById(dto.getTransactionId());

        if (existingTransactionOptional.isPresent()) {
            Transaction existingTransaction = existingTransactionOptional.get();
            existingTransaction.setType(dto.getType() != null ? dto.getType() : existingTransaction.getType());
            existingTransaction.setDateTime(dto.getDateTime() != null ? DateTimeUtil.fromOffsetToLocal(dto.getDateTime()) : existingTransaction.getDateTime());
            existingTransaction.setPaymentMethod(dto.getPaymentMethod() != null ? dto.getPaymentMethod() : existingTransaction.getPaymentMethod());
            existingTransaction.setAmount(dto.getAmount() != null ? dto.getAmount() : existingTransaction.getAmount());
            existingTransaction.setOldBalance(dto.getOldBalance() != null ? dto.getOldBalance() : existingTransaction.getOldBalance());
            existingTransaction.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingTransaction.isVisible());
            // Set other fields similarly

            return existingTransaction;
        } else {
            Transaction entity = new Transaction();
            entity.setTransactionId(dto.getTransactionId());
            entity.setType(dto.getType());
            entity.setDateTime(DateTimeUtil.fromOffsetToLocal(dto.getDateTime()));
            entity.setPaymentMethod(dto.getPaymentMethod());
            entity.setAmount(dto.getAmount());
            entity.setOldBalance(dto.getOldBalance());
            entity.setVisible(dto.getIsVisible());
            if(dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).get());
            }
            if(dto.getOrderId() != null) {
                entity.setOrder(orderRepos.findById(dto.getOrderId()).get());
            }
            // Set other fields similarly

            return entity;
        }
    }

    @Override
    public TransactionDto toDTO(Transaction entity) {
        if (entity == null) {
            return null;
        }

        TransactionDto dto = new TransactionDto();
        dto.setTransactionId(entity.getTransactionId());
        dto.setType(entity.getType());
        dto.setDateTime(DateTimeUtil.fromLocalToOffset(entity.getDateTime()));
        dto.setPaymentMethod(entity.getPaymentMethod());
        dto.setAmount(entity.getAmount());
        dto.setOldBalance(entity.getOldBalance());
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setIsVisible(entity.isVisible());
        // Set other fields similarly

        return dto;
    }
}