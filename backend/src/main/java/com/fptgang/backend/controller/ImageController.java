package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.ImagesApi;
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
public class ImageController implements ImagesApi {

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return ImagesApi.super.getRequest();
    }

    @Override
    public ResponseEntity<ImageDto> createImage(ImageDto imageDto) {
        return ImagesApi.super.createImage(imageDto);
    }

    @Override
    public ResponseEntity<Void> deleteImage(String imageId) {
        return ImagesApi.super.deleteImage(imageId);
    }

    @Override
    public ResponseEntity<ImageDto> getImageById(String imageId) {
        return ImagesApi.super.getImageById(imageId);
    }

    @Override
    public ResponseEntity<GetImages200Response> getImages(Pageable pageable, String filter, String search) {
        log.info("Getting images");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        return OpenApiHelper.respondPage(null, GetImages200Response.class);
    }

    @Override
    public ResponseEntity<ImageDto> updateImage(String imageId, ImageDto imageDto) {
        return ImagesApi.super.updateImage(imageId, imageDto);
    }
}
