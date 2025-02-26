package com.fptgang.backend.service;

import com.fptgang.backend.model.Slot;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface SlotService {
    Slot create(Slot slot);

    Slot findById(long id);

    Slot update(Slot slot);

    Slot deleteById(long id);

    Page<Slot> getAll(ListParams params);
}