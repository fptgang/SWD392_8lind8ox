package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.NotificationsApi;
import com.fptgang.backend.api.model.GetNotifications200Response;
import com.fptgang.backend.api.model.NotificationDto;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.NotificationMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Notification;
import com.fptgang.backend.service.NotificationService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    public ResponseEntity<NotificationDto> createNotification(NotificationDto notificationDto) {
        log.info("Creating notification");
        Notification notification = notificationService.create(notificationMapper.toEntity(notificationDto));
        return new ResponseEntity<>(
                notificationMapper.toDTO(notification, DetailLevel.FULL),
                HttpStatus.CREATED
        );
    }

    @Override
    public ResponseEntity<GetNotifications200Response> getNotifications(Pageable pageable, String filter, String search) {
        log.info("Getting notifications");
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter);

        // Staff and Customers can only view their own notifications
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            params.setFilter("account.accountId", "eq", SecurityUtil.requireCurrentUserId());
        }

        var res = notificationService.getAll(params.build())
                .map(n -> notificationMapper.toDTO(n, DetailLevel.SUMMARY));
        return OpenApiHelper.respondPage(res, GetNotifications200Response.class);
    }

    @Override
    public ResponseEntity<NotificationDto> updateNotification(Long notificationId, NotificationDto notificationDto) {
        notificationDto.setNotificationId(notificationId); // Override notificationId
        if(notificationDto.getAccountId() == null) {
            notificationDto.setAccountId(SecurityUtil.requireCurrentUserId()); // Override accountId
        }
        log.info("Updating notification " + notificationId);
        return ResponseEntity.ok(
                notificationMapper.toDTO(
                        notificationService.update(notificationMapper.toEntity(notificationDto)),
                        DetailLevel.FULL
                )
        );
    }
}
