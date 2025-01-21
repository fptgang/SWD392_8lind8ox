package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.NotificationsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<GetNotifications200Response> getNotifications(Pageable pageable, String filter, String search) {
        log.info("Getting notifications");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        return OpenApiHelper.respondPage(null, GetNotifications200Response.class);
    }

    @Override
    public ResponseEntity<NotificationDto> updateNotification(Integer notificationId, NotificationDto notificationDto) {
        return NotificationsApi.super.updateNotification(notificationId, notificationDto);
    }
}
