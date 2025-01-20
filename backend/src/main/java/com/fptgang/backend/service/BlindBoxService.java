package com.fptgang.backend.service;

import com.fptgang.backend.model.BlindBox;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface BlindBoxService {
    BlindBox create(BlindBox blindBox);
    BlindBox findById(long id);
    BlindBox update(BlindBox blindBox);
    BlindBox deleteById(long id);
    Page<BlindBox> getAll(Pageable pageable, String filter, boolean includeInvisible);
    default Page<BlindBox> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, false);
    }
}
