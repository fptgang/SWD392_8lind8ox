package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.PacksApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.PackMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.PackService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class PackController implements PacksApi {
    private final PackService packService;
    private final PackMapper packMapper;

    @Autowired
    public PackController(PackMapper packMapper, PackService packService) {
        this.packService = packService;
        this.packMapper = packMapper;
    }
    @Override
    public Optional<NativeWebRequest> getRequest() {
        return PacksApi.super.getRequest();
    }

    @Override
    public ResponseEntity<PackDto> createPack(PackDto packDto) {
        log.info("Creating pack");
        ResponseEntity<PackDto> response = new ResponseEntity<>(packMapper
                .toDTO(packService.create(packMapper.toEntity(packDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deletePack(Integer packId) {
        log.info("Deleting pack " + packId);
        packService.deleteById(Long.valueOf(packId));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<PackDto> getPackById(Integer packId) {
        log.info("Getting pack by id " + packId);
        return new ResponseEntity<>(packMapper.toDTO(packService.findById(Long.valueOf(packId))), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetPacks200Response> getPacks(Pageable pageable, String filter, String search) {
        log.info("Getting packs");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var res = packService.getAll(page, filter, search, includeInvisible).map(packMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetPacks200Response.class);
    }

    @Override
    public ResponseEntity<PackDto> updatePack(Integer packId, PackDto packDto) {
        log.info("Updating pack " + packId);
        return ResponseEntity.ok(packMapper.toDTO(packService.update(packMapper.toEntity(packDto))));
    }
}