package com.fptgang.backend.service;

import com.fptgang.backend.model.Message;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface MessageService {
    Message create(Message message);
    Page<Message> getAll(Pageable pageable, String filter);
    Page<Message> getAllInvolving(long participantId, Pageable pageable, String filter, String search);
}