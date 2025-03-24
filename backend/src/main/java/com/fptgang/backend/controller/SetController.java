package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.SetsApi;
import com.fptgang.backend.api.model.GetSets200Response;
import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.api.model.SetDto;
import com.fptgang.backend.api.model.SetRequestDto;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.SetMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.SetService;
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
public class SetController implements SetsApi {
    private final SetService setService;
    private final SetMapper setMapper;

    @Autowired
    public SetController(SetMapper setMapper, SetService setService) {
        this.setService = setService;
        this.setMapper = setMapper;
    }

    @Override
    public ResponseEntity<SetDto> createSet(SetRequestDto setDto) {
        log.info("Creating set");
        if (!SecurityUtil.hasRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only admin or staff can create sets");
        }
        return new ResponseEntity<>(
                setMapper.toDTO(setService.create(setMapper.toEntity(setMapper.toDTO(setDto))), DetailLevel.FULL),
                HttpStatus.CREATED
        );
    }

    @Override
    public ResponseEntity<Void> deleteSet(Long setId) {
        log.info("Deleting set " + setId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admin can delete sets");
        }
        setService.deleteById(setId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<SetDto> getSetById(Long setId) {
        log.info("Getting set by id " + setId);
//        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
//            throw new AccessDeniedException("Only admins can view detailed set info.");
//        }
        return new ResponseEntity<>(setMapper.toDTO(setService.findById(setId), DetailLevel.FULL), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetSets200Response> getSets(Pageable pageable, String filter, String search) {
        log.info("Getting sets");
        var includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        var params = ListParams.builder()
                .pageable(OpenApiHelper.toPageable(pageable))
                .search(search)
                .filter(filter)
                .includeInvisible(includeInvisible);

        var res = setService.getAll(params.build()).map(s -> setMapper.toDTO(s, DetailLevel.SUMMARY));
        return OpenApiHelper.respondPage(res, GetSets200Response.class);
    }

    @Override
    public ResponseEntity<SetDto> updateSet(Long setId, SetRequestDto setDto) {
        setDto.setSetId(setId); // Override setId
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can update sets.");
        }
        return ResponseEntity.ok(
                setMapper.toDTO(
                        setService.update(setMapper.toEntity(setMapper.toDTO(setDto))),
                        DetailLevel.FULL
                )
        );
    }
}