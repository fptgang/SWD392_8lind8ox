package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Notification;
import com.fptgang.backend.repository.NotificationRepos;
import com.fptgang.backend.service.NotificationService;
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
        if (notification.getNotificationId() == null) {
            throw new IllegalArgumentException("Notification does not exist");
        }
        return notificationRepos.save(notification);
    }

    @Override
    public Notification deleteById(long id) {
        Notification notification = notificationRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Notification does not exist"));
//        notification.setVisible(false);
        return notificationRepos.save(notification);
    }

    @Override
    public Page<Notification> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Notification>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return notificationRepos.findAll(spec, pageable);
    }
}