package com.fptgang.backend.service;

import com.fptgang.backend.model.Conversation;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface ConversationService {
    Conversation create(Conversation conversation);

    Conversation findById(long id);

    Conversation findOrCreateConversation(Long userId, Long staffId);

    Conversation findByUserIdAndStaffId(Long userId, Long staffId);

    Conversation update(Conversation conversation);

    Conversation deleteById(long id);

    Page<Conversation> getAll(ListParams params);

    Page<Conversation> getConversationsForUser(Long userId, ListParams params);

    Page<Conversation> getConversationsForStaff(Long staffId, ListParams params);
}