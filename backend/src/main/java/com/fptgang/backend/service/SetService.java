package com.fptgang.backend.service;

import com.fptgang.backend.model.Set;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface SetService {
    Set create(Set set);

    Set findById(long id);

    Set update(Set set);

    Set deleteById(long id);

    Page<Set> getAll(ListParams params);
}