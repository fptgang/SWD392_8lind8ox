package com.fptgang.backend.service;

import com.fptgang.backend.model.Set;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface SetService {
    Set create(Set set);

    Set findById(long id);

    Set update(Set set);

    Set deleteById(long id);

    Page<Set> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);

    default Page<Set> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }

    default Page<Set> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}