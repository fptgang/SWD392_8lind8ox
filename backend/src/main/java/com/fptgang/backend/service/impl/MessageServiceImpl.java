package com.fptgang.backend.service.impl;

import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.model.Message;
import com.fptgang.backend.repository.MessageRepos;
import com.fptgang.backend.service.MessageService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import com.fptgang.backend.util.OpenApiHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class MessageServiceImpl implements MessageService {
    private final MessageRepos messageRepos;

    public MessageServiceImpl(MessageRepos messageRepos) {
        this.messageRepos = messageRepos;
    }

    @Override
    @Transactional
    public Message create(Message message) {
        message.setMessageId(null);
        message = messageRepos.save(message);
        return message;
    }


    @Override
    public Page<Message> getAll(ListParams  params) {
        var pageable = params.getPageable();
        var spec = params.<Message>toSpec();
        return messageRepos.findAll(spec,pageable);
    }

    @Override
    public Page<Message> getAllInvolving(long participantId, Pageable pageable, String filter, String search) {
        var spec = OpenApiHelper.<Message>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        spec = spec.and((root, query, criteriaBuilder) -> criteriaBuilder.or(
                criteriaBuilder.equal(root.get("conversation").get("user").get("accountId"), participantId),
                criteriaBuilder.equal(root.get("conversation").get("staff").get("accountId"), participantId)
                ));
        return messageRepos.findAll(spec, pageable);
    }
}