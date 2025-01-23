//package com.fptgang.backend.controller;
//
//import com.fptgang.backend.api.controller.NotificationsApi;
//import com.fptgang.backend.api.model.*;
//import com.fptgang.backend.mapper.NotificationMapper;
//import com.fptgang.backend.model.Role;
//import com.fptgang.backend.service.NotificationService;
//import com.fptgang.backend.util.OpenApiHelper;
//import com.fptgang.backend.util.SecurityUtil;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.context.request.NativeWebRequest;
//
//import java.util.Optional;
//
//@Slf4j
//@RestController
//@RequestMapping("/api/v1")
//public class NotificationController implements NotificationsApi {
//
//    private final NotificationService notificationService;
//    private final NotificationMapper notificationMapper;
//
//    public NotificationController(NotificationService notificationService, NotificationMapper notificationMapper) {
//        this.notificationService = notificationService;
//        this.notificationMapper = notificationMapper;
//    }
//
//    @Override
//    public Optional<NativeWebRequest> getRequest() {
//        return NotificationsApi.super.getRequest();
//    }
//
//    @Override
//    public ResponseEntity<NotificationDto> createNotification(NotificationDto notificationDto) {
//        log.info("Creating notification");
//        ResponseEntity<NotificationDto> response = new ResponseEntity<>(notificationMapper
//                .toDTO(notificationService.create(notificationMapper.toEntity(notificationDto))), HttpStatus.CREATED);
//        return response;
//    }
//
//    @Override
//    public ResponseEntity<Void> deleteNotification(Integer notificationId) {
//        log.info("Deleting notification " + notificationId);
//        notificationService.deleteById(Long.valueOf(notificationId));
//        return new ResponseEntity<>(HttpStatus.OK);
//    }
//
//    @Override
//    public ResponseEntity<NotificationDto> getNotificationById(Integer notificationId) {
//        log.info("Getting notification by id " + notificationId);
//        return new ResponseEntity<>(notificationMapper.toDTO(notificationService.findById(Long.valueOf(notificationId))), HttpStatus.OK);
//    }
//
//    @Override
//    public ResponseEntity<GetNotifications200Response> getNotifications(Pageable pageable, String filter, String search) {
//        log.info("Getting notifications");
//        var page = OpenApiHelper.toPageable(pageable);
//        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
//        var res = notificationService.getAll(page, filter, search, includeInvisible).map(notificationMapper::toDTO);
//        return OpenApiHelper.respondPage(res, GetNotifications200Response.class);
//    }
//
//    @Override
//    public ResponseEntity<NotificationDto> updateNotification(Integer notificationId, NotificationDto notificationDto) {
//        log.info("Updating notification " + notificationId);
//        return ResponseEntity.ok(notificationMapper.toDTO(notificationService.update(notificationMapper.toEntity(notificationDto))));
//    }
//}
