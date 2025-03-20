package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.VideosApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.VideoMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Video;
import com.fptgang.backend.service.VideoService;
import com.fptgang.backend.service.VoucherService;
import com.fptgang.backend.service.params.ListParams;
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
    private final VoucherService voucherService;

    public VideoController(VideoService videoService, VideoMapper videoMapper, VoucherService voucherService) {
        this.videoService = videoService;
        this.videoMapper = videoMapper;
        this.voucherService = voucherService;
    }

    @Override
    public ResponseEntity<VideoDto> createVideo(Long accountID, Long slotId, MultipartFile videoBlob, Boolean isVisible) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            // Not admin, so let's ensure the user matches accountID
            long currentUserId = SecurityUtil.requireCurrentUserId(); // throws AccessDeniedException if unauthenticated
            if (currentUserId != accountID) {
                throw new AccessDeniedException("You are not allowed to create a video for another user!");
            }
        }
        VideoDto dto = new VideoDto();
        dto.setAccount(new AccountDto().accountId(accountID));
        dto.setSlotId(slotId);
        dto.setIsVisible(isVisible);
        return new ResponseEntity<>(
                videoMapper.toDTO(
                        videoService.create(videoMapper.toEntity(dto), videoBlob),
                        DetailLevel.FULL
                ),
                HttpStatus.CREATED
        );
    }

    @Override
    public ResponseEntity<Void> deleteVideo(Long videoId) {
        log.info("Deleting video " + videoId);
        // 1) If user is not ADMIN, ensure the current user is the video owner
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)&& !SecurityUtil.hasPermission(Account.Role.STAFF)   ) {
            long currentUserId = SecurityUtil.requireCurrentUserId();
            Video existingVideo = videoService.findById(videoId);
            if (existingVideo.getAccount().getAccountId() != currentUserId) {
                throw new AccessDeniedException("You are not allowed to delete this video!");
            }
        }
        videoService.deleteById(videoId);
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
        return new ResponseEntity<>(
                videoMapper.toDTO(videoService.findById(videoId), DetailLevel.FULL),
                HttpStatus.OK
        );
    }

    @Override
    public ResponseEntity<GetVideos200Response> getVideos(Pageable pageable, String filter, String search) {
        log.info("Getting videos");
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter);

        // Customers can only view their own videos
        if (!SecurityUtil.hasPermission(Account.Role.STAFF)) {
            params.setFilter("account.accountId", "eq", SecurityUtil.getCurrentUserId());
        }

        var res = videoService.getAll(params.build())
                .map(v -> videoMapper.toDTO(v, DetailLevel.SUMMARY));
        return OpenApiHelper.respondPage(res, GetVideos200Response.class);
    }

    @Override
    public ResponseEntity<VideoDto> verifiedVideo(Long videoId) {
        // 1) If user is not ADMIN, ensure the current user is the video owner
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN) && !SecurityUtil.hasPermission(Account.Role.STAFF)) {
            throw new AccessDeniedException("You are not allowed to update this video!");
        }

        Video existingVideo = videoService.findById(videoId);
        voucherService.createForCustomerId(existingVideo.getAccount().getAccountId());

        return ResponseEntity.ok(
                videoMapper.toDTO(
                        videoService.verified(videoId),
                        DetailLevel.FULL
                )
        );
    }
}
