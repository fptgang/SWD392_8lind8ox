package com.fptgang.backend.service.impl;

import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.NotificationMapper;
import com.fptgang.backend.model.Notification;
import com.fptgang.backend.repository.NotificationRepos;
import com.fptgang.backend.service.NotificationService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepos notificationRepos;
    private final SimpMessagingTemplate messagingTemplate;
    private final NotificationMapper notificationMapper;

    @Autowired
    public NotificationServiceImpl(NotificationRepos notificationRepos, SimpMessagingTemplate messagingTemplate, NotificationMapper notificationMapper) {
        this.notificationRepos = notificationRepos;
        this.messagingTemplate = messagingTemplate;
        this.notificationMapper = notificationMapper;
    }

    @Override
    public Notification create(Notification notification) {
        notification = notificationRepos.save(notification);
        messagingTemplate.convertAndSend(
                "noti/"+notification.getAccount().getEmail(),
                notificationMapper.toDTO(notification, DetailLevel.FULL)
        );
        return notificationRepos.save(notification);
    }

    @Override
    public Notification findById(long id) {
        return notificationRepos.findById(id).orElse(null);
    }

    @Override
    public Notification update(Notification notification) {
        Notification existing = notificationRepos.findById(notification.getNotificationId())
                .orElseThrow(() -> new IllegalArgumentException("Notification does not exist"));
        EntityUtil.merge(existing, notification);
        return notificationRepos.save(existing);
    }

    @Override
    public Notification deleteById(long id) {
        Notification notification = notificationRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Notification does not exist"));
//        notification.setIsVisible(false);
        return notificationRepos.save(notification);
    }

    @Override
    public Page<Notification> getAll(ListParams params) {
        var spec = params.<Notification>toSpec();
        return notificationRepos.findAll(spec, params.getPageable());
    }
}