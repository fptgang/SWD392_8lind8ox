package com.fptgang.backend.service;

import com.fptgang.backend.model.Video;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface VideoService {
    Video create(Video video);
    Video findById(long id);
    Video update(Video video);
    Video deleteById(long id);
    Page<Video> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Video> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Video> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}