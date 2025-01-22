package com.fptgang.backend.service;

import com.fptgang.backend.model.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface CategoryService {
    Category create(Category category);
    Category findById(long id);
    Category update(Category category);
    Category deleteById(long id);
    Page<Category> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Category> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Category> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}