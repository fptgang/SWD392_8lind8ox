package com.fptgang.backend.service;

import com.fptgang.backend.model.Brand;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface BrandService {
    Brand create(Brand brand);
    Brand findById(long id);
    Brand update(Brand brand);
    Brand deleteById(long id);
    Page<Brand> getAll(ListParams params);
}