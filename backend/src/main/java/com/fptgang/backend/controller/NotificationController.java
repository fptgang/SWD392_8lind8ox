package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.NotificationsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.NotificationMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Notification;
import com.fptgang.backend.service.NotificationService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class NotificationController implements NotificationsApi {

    private final NotificationService notificationService;
    private final NotificationMapper notificationMapper;
    private final SimpMessagingTemplate messagingTemplate;

    @Autowired
    public NotificationController(NotificationService notificationService, NotificationMapper notificationMapper, SimpMessagingTemplate messagingTemplate) {
        this.notificationService = notificationService;
        this.notificationMapper = notificationMapper;
        this.messagingTemplate = messagingTemplate;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return NotificationsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<NotificationDto> createNotification(NotificationDto notificationDto) {
        log.info("Creating notification");
        Notification notification = notificationService.create(notificationMapper.toEntity(notificationDto));
        messagingTemplate.convertAndSend("noti/"+notification.getAccount().getEmail(), notificationMapper.toDTO(notification));
        ResponseEntity<NotificationDto> response = new ResponseEntity<>(notificationMapper
                .toDTO(notification), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<GetNotifications200Response> getNotifications(Pageable pageable, String filter, String search) {
        log.info("Getting notifications");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var res = notificationService.getAll(page, filter, search, includeInvisible).map(notificationMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetNotifications200Response.class);
    }

    @Override
    public ResponseEntity<NotificationDto> updateNotification(Long notificationId, NotificationDto notificationDto) {
        notificationDto.setNotificationId(notificationId); // Override notificationId

        log.info("Updating notification " + notificationId);
        return ResponseEntity.ok(notificationMapper.toDTO(notificationService.update(notificationMapper.toEntity(notificationDto))));
    }
}
