package com.fptgang.backend.service;

import com.fptgang.backend.model.Slot;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface SlotService {
    Slot create(Slot slot);

    Slot findById(long id);

    Slot update(Slot slot);

    Slot deleteById(long id);

    Page<Slot> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);

    default Page<Slot> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }

    default Page<Slot> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}