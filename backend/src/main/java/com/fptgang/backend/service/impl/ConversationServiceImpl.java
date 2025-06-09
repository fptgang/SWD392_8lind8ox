package com.fptgang.backend.service.impl;

import com.fptgang.backend.exception.ResourceNotFoundException;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Conversation;
import com.fptgang.backend.repository.ConversationRepos;
import com.fptgang.backend.service.ConversationService;
import com.fptgang.backend.service.params.ListParams;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
public class ConversationServiceImpl implements ConversationService {

    private final ConversationRepos conversationRepos;

    @Autowired
    public ConversationServiceImpl(ConversationRepos conversationRepos) {
        this.conversationRepos = conversationRepos;
    }

    @Override
    @Transactional
    public Conversation create(Conversation conversation) {
        log.info("Creating conversation between user {} and staff {}",
                conversation.getUser().getAccountId(),
                conversation.getStaff() != null ? conversation.getStaff().getAccountId() : "null");
        return conversationRepos.save(conversation);
    }

    @Override
    public Conversation findById(long id) {
        return conversationRepos.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Conversation not found with id: " + id));
    }

    @Override
    @Transactional
    public Conversation findOrCreateConversation(Long userId, Long staffId) {
        // Try to find existing conversation
        Optional<Conversation> existingConversation = findExistingConversation(userId, staffId);

        if (existingConversation.isPresent()) {
            return existingConversation.get();
        }

        // Create new conversation
        Conversation newConversation = new Conversation();
        Account user = new Account();
        user.setAccountId(userId);
        newConversation.setUser(user);

        if (staffId != null) {
            Account staff = new Account();
            staff.setAccountId(staffId);
            newConversation.setStaff(staff);
        }

        return create(newConversation);
    }

    @Override
    public Conversation findByUserIdAndStaffId(Long userId, Long staffId) {
        return findExistingConversation(userId, staffId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Conversation not found between user " + userId + " and staff " + staffId));
    }

    private Optional<Conversation> findExistingConversation(Long userId, Long staffId) {
        Specification<Conversation> spec = (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            predicates.add(criteriaBuilder.equal(root.get("user").get("accountId"), userId));

            if (staffId != null) {
                predicates.add(criteriaBuilder.equal(root.get("staff").get("accountId"), staffId));
            } else {
                predicates.add(criteriaBuilder.isNull(root.get("staff")));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

        return conversationRepos.findOne(spec);
    }

    @Override
    @Transactional
    public Conversation update(Conversation conversation) {
        Conversation existing = findById(conversation.getId());

        if (conversation.getUser() != null) {
            existing.setUser(conversation.getUser());
        }
        if (conversation.getStaff() != null) {
            existing.setStaff(conversation.getStaff());
        }

        log.info("Updating conversation {}", conversation.getId());
        return conversationRepos.save(existing);
    }

    @Override
    @Transactional
    public Conversation deleteById(long id) {
        Conversation conversation = findById(id);
        conversationRepos.delete(conversation);
        log.info("Deleted conversation {}", id);
        return conversation;
    }

    @Override
    public Page<Conversation> getAll(ListParams params) {
        Specification<Conversation> spec = params.toSpec();
        return conversationRepos.findAll(spec, params.getPageable());
    }

    @Override
    public Page<Conversation> getConversationsForUser(Long userId, ListParams params) {
        Specification<Conversation> userSpec = (root, query, criteriaBuilder) -> criteriaBuilder
                .equal(root.get("user").get("accountId"), userId);

        Specification<Conversation> baseSpec = params.toSpec();
        Specification<Conversation> combinedSpec = Specification.where(baseSpec).and(userSpec);
        return conversationRepos.findAll(combinedSpec, params.getPageable());
    }

    @Override
    public Page<Conversation> getConversationsForStaff(Long staffId, ListParams params) {
        Specification<Conversation> staffSpec = (root, query, criteriaBuilder) -> criteriaBuilder
                .equal(root.get("staff").get("accountId"), staffId);

        Specification<Conversation> baseSpec = params.toSpec();
        Specification<Conversation> combinedSpec = Specification.where(baseSpec).and(staffSpec);
        return conversationRepos.findAll(combinedSpec, params.getPageable());
    }
}