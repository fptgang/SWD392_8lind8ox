package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.ImagesApi;
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
    public ResponseEntity<GetImages200Response> getImages(GetAccountsPageableParameter pageable, String filter) {
        return ImagesApi.super.getImages(pageable, filter);
    }

    @Override
    public ResponseEntity<ImageDto> updateImage(String imageId, ImageDto imageDto) {
        return ImagesApi.super.updateImage(imageId, imageDto);
    }
}
