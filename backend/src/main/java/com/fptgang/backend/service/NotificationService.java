package com.fptgang.backend.service;

import com.fptgang.backend.model.Notification;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface NotificationService {
    Notification create(Notification notification);
    Notification findById(long id);
    Notification update(Notification notification);
    Notification deleteById(long id);
    Page<Notification> getAll(Pageable pageable, String filter, boolean includeInvisible);
    default Page<Notification> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, false);
    }
}