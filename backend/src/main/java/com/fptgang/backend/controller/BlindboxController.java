package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.BlindBoxesApi;
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
public class BlindboxController implements BlindBoxesApi {

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return BlindBoxesApi.super.getRequest();
    }

    @Override
    public ResponseEntity<BlindBoxDto> createBlindBox(BlindBoxDto blindBoxDto) {
        return BlindBoxesApi.super.createBlindBox(blindBoxDto);
    }

    @Override
    public ResponseEntity<Void> deleteBlindBox(Integer blindBoxId) {
        return BlindBoxesApi.super.deleteBlindBox(blindBoxId);
    }

    @Override
    public ResponseEntity<BlindBoxDto> getBlindBoxById(Integer blindBoxId) {
        return BlindBoxesApi.super.getBlindBoxById(blindBoxId);
    }

    @Override
    public ResponseEntity<GetBlindBoxes200Response> getBlindBoxes(Pageable pageable, String filter, String search) {
        log.info("Getting blindboxes");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        return OpenApiHelper.respondPage(null, GetBlindBoxes200Response.class);
    }

    @Override
    public ResponseEntity<BlindBoxDto> updateBlindBox(Integer blindBoxId, BlindBoxDto blindBoxDto) {
        return BlindBoxesApi.super.updateBlindBox(blindBoxId, blindBoxDto);
    }
}
