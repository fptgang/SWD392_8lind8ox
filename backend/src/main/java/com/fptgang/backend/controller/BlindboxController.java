package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.BlindBoxesApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.BlindBoxMapper;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.model.Account;

import com.fptgang.backend.service.BlindBoxService;
import com.fptgang.backend.service.params.ListParams;
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
    public ResponseEntity<BlindBoxDto> createBlindBox(BlindBoxDto blindBoxDto) {
        if (!SecurityUtil.hasRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can create blind boxes.");
        }
        return new ResponseEntity<>(
                blindBoxMapper.toDTO(
                        blindBoxService.create(blindBoxMapper.toEntity(blindBoxDto)),
                        DetailLevel.FULL
                ),
                HttpStatus.CREATED
        );
    }

    @Override
    public ResponseEntity<Void> deleteBlindBox(Long blindBoxId) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can delete blind boxes.");
        }
        blindBoxService.deleteById(blindBoxId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @Override
    public ResponseEntity<BlindBoxDto> getBlindBoxById(Long blindBoxId) {
        return new ResponseEntity<>(blindBoxMapper
                .toDTO(blindBoxService.findById(blindBoxId), DetailLevel.FULL), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetBlindBoxes200Response> getBlindBoxes(Pageable pageable, String filter, String search) {
        log.info("Getting blindboxes");
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter)
                .includeInvisible(includeInvisible);

        var res = blindBoxService.getAll(params.build())
                .map(e -> blindBoxMapper.toDTO(e, DetailLevel.SUMMARY));
        return OpenApiHelper.respondPage(res, GetBlindBoxes200Response.class);
    }

    @Override
    public ResponseEntity<BlindBoxDto> updateBlindBox(Long blindBoxId, BlindBoxDto blindBoxDto) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only staff and admins can update blind boxes.");
        }
        blindBoxDto.setBlindBoxId(blindBoxId); // Override blindBoxId

        return ResponseEntity.ok(
                blindBoxMapper.toDTO(
                        blindBoxService.update(blindBoxMapper.toEntity(blindBoxDto)),
                        DetailLevel.FULL
                ));
    }
}
