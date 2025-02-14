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

        Optional<Transaction> existingTransactionOptional = transactionRepos.findById(dto.getTransactionId()==null?0:dto.getTransactionId());

        if (existingTransactionOptional.isPresent() && dto.getTransactionId() != null) {
            Transaction existingTransaction = existingTransactionOptional.get();
            existingTransaction.setType(dto.getType() != null ? Transaction.Type.valueOf(dto.getType().getValue()) : existingTransaction.getType());
            existingTransaction.setCreatedAt(dto.getDateTime() != null ? DateTimeUtil.fromOffsetToLocal(dto.getDateTime()) : existingTransaction.getCreatedAt());
            existingTransaction.setPaymentMethod(dto.getPaymentMethod() != null ? Transaction.PaymentMethod.valueOf(dto.getPaymentMethod().getValue()) : existingTransaction.getPaymentMethod());
            existingTransaction.setAmount(dto.getAmount() != null ? dto.getAmount() : existingTransaction.getAmount());
            existingTransaction.setOldBalance(dto.getOldBalance() != null ? dto.getOldBalance() : existingTransaction.getOldBalance());
            existingTransaction.setNewBalance(dto.getNewBalance() != null ? dto.getNewBalance() : existingTransaction.getNewBalance());
            existingTransaction.setSuccess(dto.getSuccess() != null ? dto.getSuccess() : existingTransaction.isSuccess());
            // Set other fields similarly

            return existingTransaction;
        } else {
            Transaction entity = new Transaction();
//            entity.setTransactionId(dto.getTransactionId());
            entity.setType(Transaction.Type.valueOf(dto.getType().getValue()) );
            entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getDateTime()));
            entity.setPaymentMethod(Transaction.PaymentMethod.valueOf(dto.getPaymentMethod().getValue()) );
            entity.setAmount(dto.getAmount());
            entity.setSuccess(dto.getSuccess());
            if(dto.getAccountId() != null) {
                entity.setAccount(accountRepos.findById(dto.getAccountId()).orElseThrow(
                        () -> new IllegalArgumentException("Account does not exist")
                ));
            }
            if(dto.getOrderId() != null) {
                entity.setOrder(orderRepos.findById(dto.getOrderId()).orElseThrow(
                        () -> new IllegalArgumentException("Order does not exist")
                ));
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
        dto.setType(TransactionDto.TypeEnum.valueOf(entity.getType().toString()) );
        dto.setDateTime(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setPaymentMethod(TransactionDto.PaymentMethodEnum.valueOf(entity.getPaymentMethod().toString()));
        dto.setAmount(entity.getAmount());
        dto.setOldBalance(entity.getOldBalance());
        dto.setNewBalance(entity.getNewBalance());
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
        dto.setOrderId(entity.getOrder() != null ? entity.getOrder().getOrderId() : null);
        dto.setSuccess(entity.isSuccess());
        // Set other fields similarly

        return dto;
    }
}