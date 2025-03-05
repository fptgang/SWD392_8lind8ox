package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.AccountDto;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class AccountMapper extends BaseMapper<AccountDto, Account> {

    @Override
    public Account toEntity(AccountDto dto) {
        if (dto == null) {
            return null;
        }

        return Account.builder()
                .accountId(dto.getAccountId())
                .email(dto.getEmail())
                .firstName(dto.getFirstName())
                .lastName(dto.getLastName())
                .password(dto.getPassword())
                .avatarUrl(dto.getAvatarUrl())
                .balance(dto.getBalance())
                .updateBalanceAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdateBalanceAt()))
                .role(mapRoleAccount(dto.getRole()))
                .isVerified(dto.getIsVerified())
                .verifiedAt(DateTimeUtil.fromOffsetToLocal(dto.getVerifiedAt()))
                .isVisible(dto.getIsVisible())
                .createdAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()))
                .updatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()))
                .build();
    }

    @Override
    public AccountDto toDTO(Account entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        AccountDto dto = new AccountDto();
        dto.setAccountId(entity.getAccountId());
        dto.setFirstName(entity.getFirstName());
        dto.setLastName(entity.getLastName());
        dto.setAvatarUrl(entity.getAvatarUrl());
        dto.setIsVisible(entity.getIsVisible());

        if (level == DetailLevel.REFERENCE) {
            return dto; // those fields are enough
        }

        dto.setEmail(entity.getEmail());
        dto.setBalance(entity.getBalance());
        //dto.setPassword(entity.getPassword()); // DO NOT RETURN PASSWORD
        dto.setUpdateBalanceAt(DateTimeUtil.fromLocalToOffset(entity.getUpdateBalanceAt()));
        dto.setRole(mapRoleAccountDto(entity.getRole()));
        dto.setIsVerified(entity.isVerified());
        dto.setVerifiedAt(DateTimeUtil.fromLocalToOffset(entity.getVerifiedAt()));
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));

        return dto;
    }

    public Account.Role mapRoleAccount(AccountDto.RoleEnum roleEnum) {
        if (roleEnum == null) {
            return null; // Or a default Role, e.g., Role.CUSTOMER
        }

        switch (roleEnum) {
            case ADMIN:
                return Account.Role.ADMIN;
            case STAFF:
                return Account.Role.STAFF;
            case CUSTOMER:
                return Account.Role.CUSTOMER;
            default:
                throw new IllegalArgumentException("Unknown RoleEnum: " + roleEnum);
        }
    }

    public AccountDto.RoleEnum mapRoleAccountDto(Account.Role roleEnum) {
        if (roleEnum == null) {
            return null; // Or a default Role, e.g., Role.CUSTOMER
        }
        switch (roleEnum) {
            case ADMIN:
                return AccountDto.RoleEnum.ADMIN;
            case STAFF:
                return AccountDto.RoleEnum.STAFF;
            case CUSTOMER:
                return AccountDto.RoleEnum.CUSTOMER;
            default:
                throw new IllegalArgumentException("Unknown RoleEnum: " + roleEnum);
        }
    }

}