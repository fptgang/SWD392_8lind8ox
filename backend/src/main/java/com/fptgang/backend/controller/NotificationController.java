package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.NotificationsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.AccountMapper;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class NotificationController implements NotificationsApi {

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return NotificationsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<NotificationDto> createNotification(NotificationDto notificationDto) {
        return NotificationsApi.super.createNotification(notificationDto);
    }

    @Override
    public ResponseEntity<Void> deleteNotification(Integer notificationId) {
        return NotificationsApi.super.deleteNotification(notificationId);
    }

    @Override
    public ResponseEntity<NotificationDto> getNotificationById(Integer notificationId) {
        return NotificationsApi.super.getNotificationById(notificationId);
    }

    @Override
    public ResponseEntity<GetNotifications200Response> getNotifications(GetAccountsPageableParameter pageable, String filter) {
        return NotificationsApi.super.getNotifications(pageable, filter);
    }

    @Override
    public ResponseEntity<NotificationDto> updateNotification(Integer notificationId, NotificationDto notificationDto) {
        return NotificationsApi.super.updateNotification(notificationId, notificationDto);
    }
}
