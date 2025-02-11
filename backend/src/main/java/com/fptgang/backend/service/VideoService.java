package com.fptgang.backend.service;

import com.fptgang.backend.model.Video;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

public interface VideoService {
    Video create(Video video, MultipartFile file);
    Video findById(long id);
    Video update(Video video, MultipartFile file);
    Video deleteById(long id);
    Page<Video> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Video> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Video> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}