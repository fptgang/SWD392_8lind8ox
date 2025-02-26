package com.fptgang.backend.service;

import com.fptgang.backend.model.Video;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

public interface VideoService {
    Video create(Video video, MultipartFile file);
    Video findById(long id);
    Video update(Video video, MultipartFile file);
    Video deleteById(long id);
    Page<Video> getAll(ListParams params);
}