package com.fptgang.backend.service;

import com.fptgang.backend.model.Brand;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface BrandService {
    Brand create(Brand brand);
    Brand findById(long id);
    Brand update(Brand brand);
    Brand deleteById(long id);
    Page<Brand> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Brand> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Brand> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}