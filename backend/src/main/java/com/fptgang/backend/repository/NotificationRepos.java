package com.fptgang.backend.repository;

import com.fptgang.backend.model.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationRepos extends JpaSpecificationExecutor<Notification>, JpaRepository<Notification, Long> {
}
