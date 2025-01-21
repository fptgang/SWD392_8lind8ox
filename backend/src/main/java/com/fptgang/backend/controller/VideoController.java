package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.VideosApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class VideoController implements VideosApi {

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return VideosApi.super.getRequest();
    }

    @Override
    public ResponseEntity<VideoDto> createVideo(VideoDto videoDto) {
        return VideosApi.super.createVideo(videoDto);
    }

    @Override
    public ResponseEntity<Void> deleteVideo(Integer videoId) {
        return VideosApi.super.deleteVideo(videoId);
    }

    @Override
    public ResponseEntity<VideoDto> getVideoById(Integer videoId) {
        return VideosApi.super.getVideoById(videoId);
    }

    @Override
    public ResponseEntity<GetVideos200Response> getVideos(Pageable pageable, String filter, String search) {
        log.info("Getting videos");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        return OpenApiHelper.respondPage(null, GetVideos200Response.class);
    }

    @Override
    public ResponseEntity<VideoDto> updateVideo(Integer videoId, VideoDto videoDto) {
        return VideosApi.super.updateVideo(videoId, videoDto);
    }
}
