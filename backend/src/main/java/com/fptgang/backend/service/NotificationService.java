package com.fptgang.backend.service;

import com.fptgang.backend.model.Notification;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface NotificationService {
    Notification create(Notification notification);
    Notification findById(long id);
    Notification update(Notification notification);
    Notification deleteById(long id);
    Page<Notification> getAll(ListParams params);
}