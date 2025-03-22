package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.NotificationDto;
import com.fptgang.backend.model.Notification;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.util.DateTimeUtil;
import org.springframework.stereotype.Component;

@Component
public class NotificationMapper extends BaseMapper<NotificationDto, Notification> {
    private final AccountRepos accountRepos;

    public NotificationMapper(AccountRepos accountRepos) {
        this.accountRepos = accountRepos;
    }

    @Override
    public Notification toEntity(NotificationDto dto) {
        if (dto == null) {
            return null;
        }

        Notification entity = new Notification();
        entity.setNotificationId(dto.getNotificationId());
        entity.setAccount(accountRepos.getReferenceById(dto.getAccountId()));
        entity.setMessage(dto.getMessage());
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));
        entity.setUpdatedAt(DateTimeUtil.fromOffsetToLocal(dto.getUpdatedAt()));
        entity.setIsRead(dto.getIsRead());
        return entity;
    }

    @Override
    public NotificationDto toDTO(Notification entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        NotificationDto dto = new NotificationDto();
        dto.setNotificationId(entity.getNotificationId());
        dto.setMessage(entity.getMessage());
        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));
        dto.setUpdatedAt(DateTimeUtil.fromLocalToOffset(entity.getUpdatedAt()));
        dto.setIsRead(entity.getIsRead());
        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
        return dto;
    }
}