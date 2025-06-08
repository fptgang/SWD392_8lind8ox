package com.fptgang.backend.repository;

import com.fptgang.backend.model.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ConversationRepos extends JpaRepository<Conversation, Long>, JpaSpecificationExecutor<Conversation> {
    boolean existsByUser_AccountId(Long accountId);
}
