package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Notification;
import com.fptgang.backend.repository.NotificationRepos;
import com.fptgang.backend.service.NotificationService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepos notificationRepos;

    @Autowired
    public NotificationServiceImpl(NotificationRepos notificationRepos) {
        this.notificationRepos = notificationRepos;
    }

    @Override
    public Notification create(Notification notification) {
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