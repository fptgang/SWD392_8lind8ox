package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.MessageDto;
import com.fptgang.backend.model.Message;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.ConversationRepos;
import com.fptgang.backend.security.AuthContext;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class MessageMapper extends BaseMapper<MessageDto, Message> {
    private final AccountRepos accountRepos;
    private final AccountMapper accountMapper;
    private final AuthContext authContext;
    private final ConversationRepos conversationRepos;

    public MessageMapper(AccountRepos accountRepos,
                         AccountMapper accountMapper,
                         AuthContext authContext, ConversationRepos conversationRepos) {
        this.accountRepos = accountRepos;
        this.accountMapper = accountMapper;
        this.authContext = authContext;
        this.conversationRepos = conversationRepos;
    }

    @Override
    public Message toEntity(MessageDto dto) {
        if (dto == null) {
            return null;
        }

        Message entity = new Message();
        entity.setMessageId(dto.getMessageId());
        if (dto.getSender() != null && dto.getSender().getAccountId() != null) {
            entity.setSender(accountRepos.getReferenceById(dto.getSender().getAccountId()));
        }
        if( dto.getContent() != null) {
            entity.setContent(dto.getContent());
        } else {
            entity.setContent(""); // ensure content is never null
        }
        if(dto.getConversationId() != null) {
            entity.setConversation(
                    conversationRepos.findById(dto.getConversationId()).orElseThrow(
                            () -> new IllegalArgumentException("Conversation not found for ID: " + dto.getConversationId()
                    )
            ));
        }

        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));

        return entity;
    }

    @Override
    public MessageDto toDTO(Message entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        MessageDto dto = new MessageDto();
        dto.setMessageId(entity.getMessageId());

        if (level == DetailLevel.REFERENCE) {
            return dto; // those fields are enough
        }
        dto.setContent(entity.getContent());

        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));

        if(level == DetailLevel.SUMMARY) {
            return dto;
        }
        dto.setConversationId(entity.getConversation().getId());
        dto.setSender(accountMapper.toDTO(entity.getSender(), DetailLevel.REFERENCE));
        return dto;
    }
}