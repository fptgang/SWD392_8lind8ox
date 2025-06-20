package com.fptgang.backend.service;

import com.fptgang.backend.model.Message;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface MessageService {
    Message create(Message message);
    Page<Message> getAll(ListParams params);
    Page<Message> getAllInvolving(long participantId, Pageable pageable, String filter, String search);
}