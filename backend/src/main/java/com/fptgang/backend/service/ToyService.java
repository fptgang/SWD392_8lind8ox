package com.fptgang.backend.service;

import com.fptgang.backend.model.Toy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ToyService {
    Toy create(Toy toy);
    Toy findById(long id);
    Toy update(Toy toy);
    Toy deleteById(long id);
    Page<Toy> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Toy> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Toy> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}
