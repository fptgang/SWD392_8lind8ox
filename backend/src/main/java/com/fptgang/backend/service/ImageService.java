package com.fptgang.backend.service;

import com.fptgang.backend.model.Image;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ImageService {
    Image create(Image image);
    Image findById(long id);
    Image update(Image image);
    Image deleteById(long id);
    Page<Image> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Image> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Image> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}