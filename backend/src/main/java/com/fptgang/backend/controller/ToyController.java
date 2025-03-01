package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.ToysApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.ToyMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.ToyService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class ToyController implements ToysApi {

    private final ToyService toyService;

    private final ToyMapper toyMapper;

    public ToyController(ToyService toyService, ToyMapper toyMapper) {
        this.toyService = toyService;
        this.toyMapper = toyMapper;
    }


    @Override
    public ResponseEntity<ToyDto> createToy(ToyDto toyDto) {
        if (!SecurityUtil.hasRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can create blind boxes.");
        }
        ResponseEntity<ToyDto> response = new ResponseEntity<>(toyMapper
                .toDTO(toyService.create(toyMapper.toEntity(toyDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deleteToy(Long toyId) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can delete blind boxes.");
        }
        toyService.deleteById(toyId);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @Override
    public ResponseEntity<ToyDto> getToyById(Long toyId) {
        ResponseEntity<ToyDto> response = new ResponseEntity<>(toyMapper
                .toDTO(toyService.findById(toyId)), HttpStatus.OK);
        return response;
    }

    @Override
    public ResponseEntity<GetToys200Response> getToys(Pageable pageable, String filter, String search) {
        org.springframework.data.domain.Page<ToyDto> res = null;
        log.info("Getting toys" + pageable + filter + search);
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter)
                .includeInvisible(includeInvisible);


        res = toyService
                .getAll(params.build())
                .map(toyMapper::toDTO);

        log.info(res.toString());
        return OpenApiHelper.respondPage(res, GetToys200Response.class);
    }

    @Override
    public ResponseEntity<ToyDto> updateToy(Long toyId, ToyDto toyDto) {
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only staff and admins can update blind boxes.");
        }
        toyDto.setToyId(toyId); // Override toyId

        ResponseEntity<ToyDto> response = new ResponseEntity<>(toyMapper
                .toDTO(toyService.update(toyMapper.toEntity(toyDto))), HttpStatus.OK);
        return response;
    }
}
