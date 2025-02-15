package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Video;
import com.fptgang.backend.repository.VideoRepos;
import com.fptgang.backend.service.AzureBlobService;
import com.fptgang.backend.service.VideoService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
@Slf4j
public class VideoServiceImpl implements VideoService {

    private final VideoRepos videoRepos;
    private final AzureBlobService azureBlobService;
    @Autowired
    public VideoServiceImpl(VideoRepos videoRepos, AzureBlobService azureBlobService) {
        this.videoRepos = videoRepos;
        this.azureBlobService = azureBlobService;
    }

    @Override
    public Video create(Video video, MultipartFile file) {
        try {
            video.setUrl(azureBlobService.upload(file, file.getName()));
            return videoRepos.save(video);
        } catch (IOException e) {
            log.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    public Video findById(long id) {
        return videoRepos.findById(id).orElse(null);
    }

    @Override
    public Video update(Video video, MultipartFile file) {
        if (video.getVideoId() == null) {
            throw new IllegalArgumentException("Video does not exist");
        }
        try {
            video.setUrl(azureBlobService.upload(file, file.getName()));
            return videoRepos.save(video);
        } catch (IOException e) {
            log.error(e.getMessage());
            throw new RuntimeException(e);
        }
    }

    @Override
    public Video deleteById(long id) {
        Video video = videoRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Video does not exist"));
        video.setVisible(false);
        return videoRepos.save(video);
    }

    @Override
    public Page<Video> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Video>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return videoRepos.findAll(spec, pageable);
    }
}