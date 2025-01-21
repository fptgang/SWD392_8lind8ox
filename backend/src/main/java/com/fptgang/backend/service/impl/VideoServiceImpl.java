package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Video;
import com.fptgang.backend.repository.VideoRepos;
import com.fptgang.backend.service.VideoService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VideoServiceImpl implements VideoService {
    private static final List<String> WHITELIST_PATHS =
            List.of(
                    "videoId",
                    "url",
                    "description",
                    "uploadDate",
                    "createdAt",
                    "updatedAt"
            );

    private final VideoRepos videoRepos;

    @Autowired
    public VideoServiceImpl(VideoRepos videoRepos) {
        this.videoRepos = videoRepos;
    }

    @Override
    public Video create(Video video) {
        return videoRepos.save(video);
    }

    @Override
    public Video findById(long id) {
        return videoRepos.findById(id).orElse(null);
    }

    @Override
    public Video update(Video video) {
        if (video.getVideoId() == null) {
            throw new IllegalArgumentException("Video does not exist");
        }
        return videoRepos.save(video);
    }

    @Override
    public Video deleteById(long id) {
        Video video = videoRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Video does not exist"));
        video.setVisible(false);
        return videoRepos.save(video);
    }

    @Override
    public Page<Video> getAll(Pageable pageable, String filter, boolean includeInvisible) {
        var spec = OpenApiHelper.<Video>toSpecification(filter, WHITELIST_PATHS);
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return videoRepos.findAll(spec, pageable);
    }
}