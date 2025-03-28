package com.fptgang.backend.service.impl;

import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.model.Slot;
import com.fptgang.backend.repository.SlotRepos;
import com.fptgang.backend.service.SlotService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class SlotServiceImpl implements SlotService {

    private final SlotRepos slotRepos;
    private final SimpMessagingTemplate simpMessagingTemplate;

    @Autowired
    public SlotServiceImpl(SlotRepos slotRepos, SimpMessagingTemplate simpMessagingTemplate) {
        this.slotRepos = slotRepos;
        this.simpMessagingTemplate = simpMessagingTemplate;
    }

    @Override
    public Slot create(Slot slot) {
        return slotRepos.save(slot);
    }

    @Override
    public Slot findById(long id) {
        return slotRepos.findById(id).orElse(null);
    }

    @Override
    public Slot update(Slot slot) {
        Slot existing = slotRepos.findById(slot.getSlotId())
                .orElseThrow(() -> new IllegalArgumentException("Slot does not exist"));
        EntityUtil.merge(existing, slot);
        simpMessagingTemplate.convertAndSend(
                "resources/sets", existing.getSlotId()
        );
        return slotRepos.save(existing);
    }

    @Override
    public Slot deleteById(long id) {
        Slot slot = slotRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Slot does not exist"));
//        slot.slotVisible(false);
        return slotRepos.save(slot);
    }

    @Override
    public Page<Slot> getAll(ListParams params) {
        var spec = params.<Slot>toSpec();
        return slotRepos.findAll(spec, params.getPageable());
    }
}