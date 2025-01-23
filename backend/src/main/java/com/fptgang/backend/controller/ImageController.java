package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.ImagesApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.ImageMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.ImageService;
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
    public ResponseEntity<ImageDto> createImage(ImageDto imageDto) {
        log.info("Creating image");
        ResponseEntity<ImageDto> response = new ResponseEntity<>(imageMapper
                .toDTO(imageService.create(imageMapper.toEntity(imageDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deleteImage(String imageId) {
        log.info("Deleting image " + imageId);
        imageService.deleteById(Long.valueOf(imageId));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<ImageDto> getImageById(String imageId) {
        log.info("Getting image by id " + imageId);
        return new ResponseEntity<>(imageMapper.toDTO(imageService.findById(Long.valueOf(imageId))), HttpStatus.OK);
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
    public ResponseEntity<ImageDto> updateImage(String imageId, ImageDto imageDto) {
        log.info("Updating image " + imageId);
        return ResponseEntity.ok(imageMapper.toDTO(imageService.update(imageMapper.toEntity(imageDto))));
    }
}
