//package com.fptgang.backend.mapper;
//
//import com.fptgang.backend.api.model.NotificationDto;
//import com.fptgang.backend.model.Notification;
//import com.fptgang.backend.repository.AccountRepos;
//import com.fptgang.backend.repository.NotificationRepos;
//import com.fptgang.backend.util.DateTimeUtil;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import java.util.Optional;
//
//@Component
//public class NotificationMapper extends BaseMapper<NotificationDto, Notification> {
//
//    @Autowired
//    private NotificationRepos notificationRepos;
//    @Autowired
//    private AccountRepos accountRepos;
//
//    @Override
//    public Notification toEntity(NotificationDto dto) {
//        if (dto == null) {
//            return null;
//        }
//
//        Optional<Notification> existingNotificationOptional = notificationRepos.findById(dto.getNotificationId());
//
//        if (existingNotificationOptional.isPresent()) {
//            Notification existingNotification = existingNotificationOptional.get();
//            existingNotification.setMessage(dto.getMessage() != null ? dto.getMessage() : existingNotification.getMessage());
//            existingNotification.setCreatedDate(dto.getCreatedDate() != null ? dto.getCreatedDate().toLocalDateTime() : existingNotification.getCreatedDate());
//            existingNotification.setRead(dto.getIsRead() != null ? dto.getIsRead() : existingNotification.isRead());
//            existingNotification.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : existingNotification.isVisible());
//            if(dto.getAccountId() != null) {
//                existingNotification.setAccount(accountRepos.findById(dto.getAccountId()).get());
//            }
//
//            return existingNotification;
//        } else {
//            Notification entity = new Notification();
//            entity.setNotificationId(dto.getNotificationId());
//            entity.setMessage(dto.getMessage());
//            entity.setCreatedDate(dto.getCreatedDate().toLocalDateTime());
//            entity.setRead(dto.getIsRead());
//            entity.setVisible(dto.getIsVisible() != null ? dto.getIsVisible() : entity.isVisible());
//            if(dto.getAccountId() != null) {
//                entity.setAccount(accountRepos.findById(dto.getAccountId()).get());
//            }
//            if(dto.getCreatedDate() != null) {
//                entity.setCreatedDate(dto.getCreatedDate().toLocalDateTime());
//            }
//            return entity;
//        }
//    }
//
//    @Override
//    public NotificationDto toDTO(Notification entity) {
//        if (entity == null) {
//            return null;
//        }
//
//        NotificationDto dto = new NotificationDto();
//        dto.setNotificationId(entity.getNotificationId());
//        dto.setMessage(entity.getMessage());
//        dto.setCreatedDate(DateTimeUtil.fromLocalToOffset(entity.getCreatedDate()));
//        dto.setIsRead(entity.isRead());
//        dto.setAccountId(entity.getAccount() != null ? entity.getAccount().getAccountId() : null);
//        dto.setIsVisible(entity.isVisible());
//        if(entity.getCreatedDate() != null) {
//            dto.setCreatedDate(DateTimeUtil.fromLocalToOffset(entity.getCreatedDate()));
//        }
//        return dto;
//    }
//}