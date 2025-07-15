package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.ConversationsApi;
import com.fptgang.backend.api.model.ConversationDto;
import com.fptgang.backend.api.model.GetBlindBoxes200Response;
import com.fptgang.backend.api.model.GetConversations200Response;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.mapper.ConversationMapper;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Conversation;
import com.fptgang.backend.service.ConversationService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/conversations")
public class ConversationController implements ConversationsApi {        

    private final ConversationService conversationService;
    private final ConversationMapper conversationMapper;

    @Autowired
    public ConversationController(ConversationService conversationService, ConversationMapper conversationMapper) {
        this.conversationService = conversationService;
        this.conversationMapper = conversationMapper;
    }

    @Override
    public ResponseEntity<ConversationDto> createConversation(ConversationDto conversationDto) {
        log.info("Creating conversation");

        // Set the current user as the user in conversation if not staff/admin
        if (!SecurityUtil.hasRole(Account.Role.STAFF, Account.Role.ADMIN)) {
            if (conversationDto.getUser() == null) {
                conversationDto.setUser(new com.fptgang.backend.api.model.AccountDto());
            }
            conversationDto.getUser().setAccountId(SecurityUtil.requireCurrentUserId());
        }

        Conversation conversation = conversationMapper.toEntity(conversationDto);
        conversation = conversationService.create(conversation);

        return new ResponseEntity<>(
                conversationMapper.toDTO(conversation, DetailLevel.FULL),
                HttpStatus.CREATED);
    }

    /**
     * Get conversation by ID
     */
    @Override
    public ResponseEntity<ConversationDto> getConversationById(Long conversationId) {
        log.info("Getting conversation by id: {}", conversationId);

        Conversation conversation = conversationService.findById(conversationId);

        // Security check: users can only access their own conversations
        if (!SecurityUtil.hasRole(Account.Role.STAFF, Account.Role.ADMIN)) {
            Long currentUserId = SecurityUtil.requireCurrentUserId();
            if (!conversation.getUser().getAccountId().equals(currentUserId) &&
                    (conversation.getStaff() == null
                            || !conversation.getStaff().getAccountId().equals(currentUserId))) {
                throw new AccessDeniedException("You can only access your own conversations");
            }
        }

        return new ResponseEntity<>(
                conversationMapper.toDTO(conversation, DetailLevel.FULL),
                HttpStatus.OK);
    }

    /**
     * Get all conversations with filtering
     */
    @Override
    public ResponseEntity<GetConversations200Response> getConversations(
            Pageable pageable,
            String filter,
           String search) {

        log.info("Getting conversations");

        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter);

        Page<ConversationDto> result;

        if (SecurityUtil.hasRole(Account.Role.ADMIN)) {
            // Admin can see all conversations
            result = conversationService.getAll(params.build())
                    .map(c -> conversationMapper.toDTO(c, DetailLevel.SUMMARY));
        } else if (SecurityUtil.hasRole(Account.Role.STAFF)) {
            // Staff can see conversations assigned to them or unassigned ones
            Long staffId = SecurityUtil.requireCurrentUserId();
            result = conversationService.getConversationsForStaff(staffId, params.build())
                    .map(c -> conversationMapper.toDTO(c, DetailLevel.SUMMARY));
        } else {
            // Customers can only see their own conversations
            Long userId = SecurityUtil.requireCurrentUserId();
            result = conversationService.getConversationsForUser(userId, params.build())
                    .map(c -> conversationMapper.toDTO(c, DetailLevel.SUMMARY));
        }

        return  OpenApiHelper.respondPage(result, GetConversations200Response.class);
    }

    /**
     * Find or create conversation between user and staff
     */
    @Override
    public ResponseEntity<ConversationDto> findOrCreateConversation(
             Long userId, Long staffId) {

        log.info("Finding or creating conversation between user {} and staff {}", userId, staffId);

        // Security check: non-admin users can only create conversations for themselves
        if (!SecurityUtil.hasRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            if (!userId.equals(SecurityUtil.requireCurrentUserId())) {
                throw new AccessDeniedException("You can only create conversations for yourself");
            }
        }

        Conversation conversation = conversationService.findOrCreateConversation(userId, staffId);

        return new ResponseEntity<>(
                conversationMapper.toDTO(conversation, DetailLevel.FULL),
                HttpStatus.OK);
    }

    /**
     * Update conversation (mainly for assigning staff)
     */
    @Override
    public ResponseEntity<ConversationDto> updateConversation(
            Long conversationId,
                ConversationDto conversationDto) {

        log.info("Updating conversation: {}", conversationId);

        // Only staff and admin can update conversations
        if (!SecurityUtil.hasRole(Account.Role.STAFF, Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only staff and admin can update conversations");
        }

        conversationDto.setConversationId(conversationId);
        Conversation conversation = conversationMapper.toEntity(conversationDto);
        conversation = conversationService.update(conversation);

        return new ResponseEntity<>(
                conversationMapper.toDTO(conversation, DetailLevel.FULL),
                HttpStatus.OK);
    }

    /**
     * Delete conversation
     */
    @Override
    public ResponseEntity<Void> deleteConversation(Long conversationId) {
        log.info("Deleting conversation: {}", conversationId);

        // Only admin can delete conversations
        if (!SecurityUtil.hasRole(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admin can delete conversations");
        }

        conversationService.deleteById(conversationId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    /**
     * Assign staff to conversation
     */
    @Override
    public ResponseEntity<ConversationDto> assignStaffToConversation(
            Long conversationId,
             Long staffId) {

        log.info("Assigning staff {} to conversation {}", staffId, conversationId);

        // Only staff and admin can assign staff to conversations
        if (!SecurityUtil.hasRole(Account.Role.STAFF, Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only staff and admin can assign staff to conversations");
        }

        Conversation conversation = conversationService.findById(conversationId);
        Account staff = new Account();
        staff.setAccountId(staffId);
        conversation.setStaff(staff);

        conversation = conversationService.update(conversation);

        return new ResponseEntity<>(
                conversationMapper.toDTO(conversation, DetailLevel.FULL),
                HttpStatus.OK);
    }
}
