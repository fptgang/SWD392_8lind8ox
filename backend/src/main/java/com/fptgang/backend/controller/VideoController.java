package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.VideosApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.VideoMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.service.VideoService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.multipart.MultipartFile;

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
    public ResponseEntity<VideoDto> createVideo(Long accountID, Long orderDetailId, MultipartFile videoBlob,Boolean isVisible) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            // Not admin, so let's ensure the user matches accountID
            long currentUserId = SecurityUtil.requireCurrentUserId(); // throws AccessDeniedException if unauthenticated
            if (currentUserId != accountID) {
                throw new AccessDeniedException("You are not allowed to create a video for another user!");
            }
        }
        VideoDto dto = new VideoDto()
                .accountId(accountID)
                .orderDetailId(orderDetailId)
                .isVisible(isVisible);
        return new ResponseEntity<>(videoMapper
                .toDTO(videoService.create(videoMapper.toEntity(dto), videoBlob)), HttpStatus.CREATED);
    }

    @Override
    public ResponseEntity<Void> deleteVideo(Long videoId) {
        log.info("Deleting video " + videoId);
        // 1) If user is not ADMIN, ensure the current user is the video owner
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            long currentUserId = SecurityUtil.requireCurrentUserId();
            Video existingVideo = videoService.findById(videoId);
            if (existingVideo.getAccount().getAccountId() != currentUserId) {
                throw new AccessDeniedException("You are not allowed to delete this video!");
            }
        }
        videoService.deleteById(Long.valueOf(videoId));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<VideoDto> getVideoById(Long videoId) {
        log.info("Getting video by id " + videoId);
        // 1) If user is not ADMIN, ensure the current user is the video owner
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            long currentUserId = SecurityUtil.requireCurrentUserId();
            Video existingVideo = videoService.findById(videoId);
            if (existingVideo.getAccount().getAccountId() != currentUserId) {
                throw new AccessDeniedException("You are not allowed to view this video!");
            }
        }
        return new ResponseEntity<>(videoMapper.toDTO(videoService.findById(Long.valueOf(videoId))), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetVideos200Response> getVideos(Pageable pageable, String filter, String search) {
        log.info("Getting videos");
        var page = OpenApiHelper.toPageable(pageable);
        boolean hasFullAccess = SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF);

        if (!hasFullAccess) {
            long currentUserId = SecurityUtil.requireCurrentUserId();
            filter = (filter == null || filter.isEmpty()) ? "accountId==" + currentUserId : filter + ";accountId==" + currentUserId;
        }
        var res = videoService.getAll(page, filter, search, hasFullAccess).map(videoMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetVideos200Response.class);
    }

    @Override
    public ResponseEntity<VideoDto> updateVideo(Long videoId,Long accountID, Long orderDetailId, MultipartFile videoBlob,Boolean isVisible) {
        // 1) If user is not ADMIN, ensure the current user is the video owner
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            long currentUserId = SecurityUtil.requireCurrentUserId();
            Video existingVideo = videoService.findById(videoId);
            if (existingVideo.getAccount().getAccountId() != currentUserId) {
                throw new AccessDeniedException("You are not allowed to update this video!");
            }
        }
        VideoDto dto = new VideoDto()
                .videoId(videoId)
                .accountId(accountID)
                .orderDetailId(orderDetailId)
                .isVisible(isVisible);
        return ResponseEntity.ok(videoMapper
                .toDTO(videoService.update(videoMapper.toEntity(dto), videoBlob)));
    }
}
