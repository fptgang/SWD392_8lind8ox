package com.fptgang.backend.mapper;

import com.fptgang.backend.api.model.ConversationDto;
import com.fptgang.backend.model.Conversation;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.ConversationRepos;
import com.fptgang.backend.security.AuthContext;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class ConversationMapper extends BaseMapper<ConversationDto, Conversation> {
    private final AccountRepos accountRepos;
    private final AccountMapper accountMapper;
    private final AuthContext authContext;
    private final ConversationRepos conversationRepos;

    public ConversationMapper(AccountRepos accountRepos,
            AccountMapper accountMapper,
            AuthContext authContext, ConversationRepos conversationRepos) {
        this.accountRepos = accountRepos;
        this.accountMapper = accountMapper;
        this.authContext = authContext;
        this.conversationRepos = conversationRepos;
    }

    @Override
    public Conversation toEntity(ConversationDto dto) {
        if (dto == null) {
            return null;
        }

        Conversation entity = new Conversation();
        entity.setId(dto.getConversationId());

        if (dto.getUser() != null && dto.getUser().getAccountId() != null) {
            entity.setUser(accountRepos.getReferenceById(dto.getUser().getAccountId()));
        }
        if (dto.getStaff() != null && dto.getStaff().getAccountId() != null) {
            entity.setStaff(accountRepos.getReferenceById(dto.getStaff().getAccountId()));
        }
        entity.setCreatedAt(DateTimeUtil.fromOffsetToLocal(dto.getCreatedAt()));

        return entity;
    }

    @Override
    public ConversationDto toDTO(Conversation entity, DetailLevel level) {
        if (entity == null) {
            return null;
        }

        ConversationDto dto = new ConversationDto();
        dto.setConversationId(entity.getId());
        dto.setUser(accountMapper.toDTO(entity.getUser(), DetailLevel.REFERENCE));

        if (level == DetailLevel.REFERENCE) {
            return dto; // those fields are enough
        }

        dto.setCreatedAt(DateTimeUtil.fromLocalToOffset(entity.getCreatedAt()));

        if (level == DetailLevel.SUMMARY) {
            return dto;
        }
        dto.setUser(accountMapper.toDTO(entity.getUser(), DetailLevel.SUMMARY));
        dto.setStaff(accountMapper.toDTO(entity.getStaff(), DetailLevel.SUMMARY));
        return dto;
    }
}