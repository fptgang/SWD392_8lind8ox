package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.VideosApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.AccountMapper;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.service.AccountService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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
    public ResponseEntity<GetVideos200Response> getVideos(GetAccountsPageableParameter pageable, String filter) {
        return VideosApi.super.getVideos(pageable, filter);
    }

    @Override
    public ResponseEntity<VideoDto> updateVideo(Integer videoId, VideoDto videoDto) {
        return VideosApi.super.updateVideo(videoId, videoDto);
    }
}
