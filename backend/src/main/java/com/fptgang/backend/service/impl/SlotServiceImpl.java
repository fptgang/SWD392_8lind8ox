package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Slot;
import com.fptgang.backend.repository.SlotRepos;
import com.fptgang.backend.service.SlotService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class SlotServiceImpl implements SlotService {

    private final SlotRepos slotRepos;

    @Autowired
    public SlotServiceImpl(SlotRepos slotRepos) {
        this.slotRepos = slotRepos;
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
        if (slot.getSlotId() == null) {
            throw new IllegalArgumentException("Slotage does not exist");
        }
        return slotRepos.save(slot);
    }

    @Override
    public Slot deleteById(long id) {
        Slot slot = slotRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Slotage does not exist"));
//        slot.slotVisible(false);
        return slotRepos.save(slot);
    }

    @Override
    public Page<Slot> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Slot>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return slotRepos.findAll(spec, pageable);
    }
}