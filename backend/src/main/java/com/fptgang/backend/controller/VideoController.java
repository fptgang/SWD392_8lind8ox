package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.VideosApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.VideoMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.VideoService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class VideoController implements VideosApi {
    private final VideoService videoService;
    private final VideoMapper videoMapper;

    public VideoController(VideoService videoService, VideoMapper videoMapper) {
        this.videoService = videoService;
        this.videoMapper = videoMapper;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return VideosApi.super.getRequest();
    }

    @Override
    public ResponseEntity<VideoDto> createVideo(VideoDto videoDto) {
        log.info("Creating video");
        ResponseEntity<VideoDto> response = new ResponseEntity<>(videoMapper
                .toDTO(videoService.create(videoMapper.toEntity(videoDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deleteVideo(Long videoId) {
        log.info("Deleting video " + videoId);
        videoService.deleteById(Long.valueOf(videoId));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<VideoDto> getVideoById(Long videoId) {
        log.info("Getting video by id " + videoId);
        return new ResponseEntity<>(videoMapper.toDTO(videoService.findById(Long.valueOf(videoId))), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetVideos200Response> getVideos(Pageable pageable, String filter, String search) {
        log.info("Getting videos");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var res = videoService.getAll(page, filter, search, includeInvisible).map(videoMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetVideos200Response.class);
    }

    @Override
    public ResponseEntity<VideoDto> updateVideo(Long videoId, VideoDto videoDto) {
        videoDto.setVideoId(videoId); // Override videoId

        log.info("Updating video " + videoId);
        return ResponseEntity.ok(videoMapper.toDTO(videoService.update(videoMapper.toEntity(videoDto))));
    }
}
