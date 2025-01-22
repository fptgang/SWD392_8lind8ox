package com.fptgang.backend.service;

import com.fptgang.backend.model.Pack;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface PackService {
    Pack create(Pack pack);
    Pack findById(long id);
    Pack update(Pack pack);
    Pack deleteById(long id);
    Page<Pack> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Pack> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Pack> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}