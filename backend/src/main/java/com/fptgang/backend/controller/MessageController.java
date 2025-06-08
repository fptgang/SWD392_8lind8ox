package com.fptgang.backend.controller;

import com.fptgang.backend.api.model.MessageDto;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.MessageMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Conversation;
import com.fptgang.backend.model.Message;
import com.fptgang.backend.service.ConversationService;
import com.fptgang.backend.service.MessageService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/messages")
public class MessageController {

    private static final Logger log = LoggerFactory.getLogger(MessageController.class);

    @Autowired
    private MessageService messageService;

    @Autowired
    private ConversationService conversationService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private MessageMapper messageMapper;

    /**
     * Get all messages involving current user (for their conversations)
     */
    @GetMapping
    public ResponseEntity<Page<MessageDto>> getMessages(Pageable pageable,
            @RequestParam(required = false) String filter,
            @RequestParam(required = false) String search) {
        log.info("Getting messages for current user");
        var page = OpenApiHelper.toPageable(pageable);
        var userId = SecurityUtil.requireCurrentUserId();

        Page<MessageDto> res = messageService
                .getAllInvolving(userId, page, filter, search)
                .map(message -> messageMapper.toDTO(message, DetailLevel.FULL));
        return new ResponseEntity<>(res, HttpStatus.OK);
    }

    /**
     * Get messages for a specific conversation
     */
    @GetMapping("/conversation/{conversationId}")
    public ResponseEntity<Page<MessageDto>> getMessagesForConversation(@PathVariable Long conversationId,
            Pageable pageable,
            @RequestParam(required = false) String filter,
            @RequestParam(required = false) String search) {
        log.info("Getting messages for conversation: {}", conversationId);

        // Verify user has access to this conversation
        Conversation conversation = conversationService.findById(conversationId);
        Long currentUserId = SecurityUtil.requireCurrentUserId();

        if (!SecurityUtil.hasRole(Account.Role.ADMIN)) {
            boolean hasAccess = conversation.getUser().getAccountId().equals(currentUserId) ||
                    (conversation.getStaff() != null && conversation.getStaff().getAccountId().equals(currentUserId));

            if (!hasAccess) {
                throw new AccessDeniedException("You don't have access to this conversation");
            }
        }

        var page = OpenApiHelper.toPageable(pageable);

        // Build filter to include conversation ID
        String conversationFilter = filter != null ? filter + ",conversation.id:eq:" + conversationId
                : "conversation.id:eq:" + conversationId;

        Page<MessageDto> res = messageService.getAll(page, conversationFilter)
                .map(message -> messageMapper.toDTO(message, DetailLevel.FULL));

        return new ResponseEntity<>(res, HttpStatus.OK);
    }

    /**
     * Send a message via REST API
     */
    @PostMapping
    @Transactional
    public ResponseEntity<MessageDto> sendMessage(@RequestBody MessageDto messageDto) {
        log.info("Sending message via REST API");

        // Set sender to current user
        Long currentUserId = SecurityUtil.requireCurrentUserId();
        if (messageDto.getSender() == null) {
            messageDto.setSender(new com.fptgang.backend.api.model.AccountDto().accountId(currentUserId));
        } else {
            messageDto.getSender().setAccountId(currentUserId);
        }

        // Verify access to conversation
        if (messageDto.getConversationId() != null) {
            Conversation conversation = conversationService.findById(messageDto.getConversationId());

            if (!SecurityUtil.hasRole(Account.Role.ADMIN)) {
                boolean hasAccess = conversation.getUser().getAccountId().equals(currentUserId) ||
                        (conversation.getStaff() != null
                                && conversation.getStaff().getAccountId().equals(currentUserId));

                if (!hasAccess) {
                    throw new AccessDeniedException("You don't have access to this conversation");
                }
            }
        }

        Message message = messageMapper.toEntity(messageDto);
        message = messageService.create(message);
        MessageDto responseDto = messageMapper.toDTO(message, DetailLevel.FULL);

        // Send via WebSocket as well
        broadcastMessage(message, responseDto);

        return new ResponseEntity<>(responseDto, HttpStatus.CREATED);
    }

    /**
     * WebSocket message handler for real-time chat
     */
    @MessageMapping("/chat.sendMessage/{conversationId}")
    @Transactional
    public void sendMessageViaWebSocket(@DestinationVariable Long conversationId, @Payload MessageDto messageDto) {
        try {
            log.info("Sending message via WebSocket for conversation: {}", conversationId);

            // Verify conversation exists
            Conversation conversation = conversationService.findById(conversationId);

            // Set conversation ID
            messageDto.setConversationId(conversationId);

            // Create and save message
            Message message = messageMapper.toEntity(messageDto);
            message = messageService.create(message);
            MessageDto responseDto = messageMapper.toDTO(message, DetailLevel.FULL);

            // Broadcast to conversation participants
            broadcastMessage(message, responseDto);

        } catch (Exception e) {
            log.error("Error sending message via WebSocket", e);
            throw new RuntimeException("Failed to send message", e);
        }
    }

    /**
     * Broadcast message to conversation participants via WebSocket
     */
    private void broadcastMessage(Message message, MessageDto messageDto) {
        try {
            Conversation conversation = message.getConversation();

            // Send to user
            if (conversation.getUser() != null && conversation.getUser().getEmail() != null) {
                String userDestination = "message/"
                        + conversation.getUser().getEmail();
                messagingTemplate.convertAndSend(userDestination, messageDto);
                log.info("Sent message to user: {}", conversation.getUser().getEmail());
            }

            // Send to staff if assigned
            if (conversation.getStaff() != null && conversation.getStaff().getEmail() != null) {
                String staffDestination = "message/"
                        + conversation.getStaff().getEmail();
                messagingTemplate.convertAndSend(staffDestination, messageDto);
                log.info("Sent message to staff: {}", conversation.getStaff().getEmail());
            }

//            // Also send to general conversation topic for real-time updates
//            String conversationDestination = "/topic/conversation/" + conversation.getId();
//            messagingTemplate.convertAndSend(conversationDestination, messageDto);
//            log.info("Sent message to conversation topic: {}", conversation.getId());

        } catch (Exception e) {
            log.error("Error broadcasting message", e);
        }
    }
}
