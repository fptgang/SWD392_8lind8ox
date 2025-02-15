package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.ImagesApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.ImageMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Image;
import com.fptgang.backend.service.ImageService;
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

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class ImageController implements ImagesApi {

    private final ImageService imageService;
    private final ImageMapper imageMapper;

    public ImageController(ImageService imageService, ImageMapper imageMapper) {
        this.imageService = imageService;
        this.imageMapper = imageMapper;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return ImagesApi.super.getRequest();
    }

    @Override
    public ResponseEntity<ImageDto> uploadImage(Long uploaderId, Long blindBoxId, Long packId, MultipartFile imageBlob, Boolean isVisible) {
        if (!SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can upload images.");
        }
        ImageDto dto = new ImageDto()
                .uploaderId(uploaderId)
                .blindBoxId(blindBoxId)
                .packId(packId)
                .isVisible(isVisible);
        return new ResponseEntity<>(imageMapper
                .toDTO(imageService.create(imageMapper.toEntity(dto), imageBlob)), HttpStatus.CREATED);
    }

    @Override
    public ResponseEntity<Void> deleteImage(Long imageId) {
        log.info("Deleting image " + imageId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can delete images.");
        }
        imageService.deleteById(imageId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<ImageDto> getImageById(Long imageId) {
        log.info("Getting image by id " + imageId);
        Image image = imageService.findById(imageId);

        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            Long currentUserId = SecurityUtil.requireCurrentUserId();
            if (!image.getUploader().getAccountId().equals(currentUserId)) {
                throw new AccessDeniedException("You can only view images you uploaded.");
            }
        }

        return new ResponseEntity<>(imageMapper.toDTO(image), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetImages200Response> getImages(Pageable pageable, String filter, String search) {
        log.info("Getting images");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var res = imageService.getAll(page, filter, search, includeInvisible).map(imageMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetImages200Response.class);
    }

    @Override
    public ResponseEntity<ImageDto> updateImage(Long imageId, Long uploaderId, Long blindBoxId, Long packId, MultipartFile imageBlob, Boolean isVisible) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can update images.");
        }
        ImageDto dto = new ImageDto()
                .imageId(imageId)
                .uploaderId(uploaderId)
                .blindBoxId(blindBoxId)
                .packId(packId)
                .isVisible(isVisible);
        return ResponseEntity.ok(imageMapper
                .toDTO(imageService.update(imageMapper.toEntity(dto), imageBlob)));
    }
}
