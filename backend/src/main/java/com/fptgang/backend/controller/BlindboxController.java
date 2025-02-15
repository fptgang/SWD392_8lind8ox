package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.BlindBoxesApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.BlindBoxMapper;
import com.fptgang.backend.model.Account;

import com.fptgang.backend.service.BlindBoxService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class BlindboxController implements BlindBoxesApi {

    private final BlindBoxService blindBoxService;
    private final BlindBoxMapper blindBoxMapper;

    @Autowired
    public BlindboxController(BlindBoxMapper blindBoxMapper, BlindBoxService blindBoxService) {
        this.blindBoxService = blindBoxService;
        this.blindBoxMapper = blindBoxMapper;
    }


    @Override
    public Optional<NativeWebRequest> getRequest() {
        return BlindBoxesApi.super.getRequest();
    }

    @Override
    public ResponseEntity<BlindBoxDto> createBlindBox(BlindBoxDto blindBoxDto) {
        if (!SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can create blind boxes.");
        }
        ResponseEntity<BlindBoxDto> response = new ResponseEntity<>(blindBoxMapper
                .toDTO(blindBoxService.create(blindBoxMapper.toEntity(blindBoxDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deleteBlindBox(Long blindBoxId) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can delete blind boxes.");
        }
        return BlindBoxesApi.super.deleteBlindBox(blindBoxId);
    }

    @Override
    public ResponseEntity<BlindBoxDto> getBlindBoxById(Long blindBoxId) {
        ResponseEntity<BlindBoxDto> response = new ResponseEntity<>(blindBoxMapper
                .toDTO(blindBoxService.findById(blindBoxId)), HttpStatus.OK);
        return response;
    }

    @Override
    public ResponseEntity<GetBlindBoxes200Response> getBlindBoxes(Pageable pageable, String filter, String search) {
        org.springframework.data.domain.Page<BlindBoxDto> res = null;
        log.info("Getting blindboxes" + pageable + filter + search);
        var includeInvisible = false;
        var page = OpenApiHelper.toPageable(pageable);
        try {
             includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        } catch (Exception e) {
            log.error("Error getting blindboxes", e.getMessage());
        }

        res = blindBoxService
                .getAll(page, filter, search, includeInvisible)
                .map(blindBoxMapper::toDTO);

        log.info(res.toString());
        return OpenApiHelper.respondPage(res, GetBlindBoxes200Response.class);
    }

    @Override
    public ResponseEntity<BlindBoxDto> updateBlindBox(Long blindBoxId, BlindBoxDto blindBoxDto) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only staff and admins can update blind boxes.");
        }
        blindBoxDto.setBlindBoxId(blindBoxId); // Override blindBoxId

        ResponseEntity<BlindBoxDto> response = new ResponseEntity<>(blindBoxMapper
                .toDTO(blindBoxService.update(blindBoxMapper.toEntity(blindBoxDto))), HttpStatus.OK);
        return response;
    }
}
