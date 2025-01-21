package com.fptgang.backend.controller;
import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.BlindBoxesApi;
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
    public ResponseEntity<GetBlindBoxes200Response> getBlindBoxes(GetAccountsPageableParameter pageable, String filter) {
        return BlindBoxesApi.super.getBlindBoxes(pageable, filter);
    }

    @Override
    public ResponseEntity<BlindBoxDto> updateBlindBox(Integer blindBoxId, BlindBoxDto blindBoxDto) {
        return BlindBoxesApi.super.updateBlindBox(blindBoxId, blindBoxDto);
    }
}
