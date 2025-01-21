package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.PackagesApi;
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
public class PackageController implements PackagesApi{

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return PackagesApi.super.getRequest();
    }

    @Override
    public ResponseEntity<PackageDto> createPackage(PackageDto packageDto) {
        return PackagesApi.super.createPackage(packageDto);
    }

    @Override
    public ResponseEntity<Void> deletePackage(Integer packageId) {
        return PackagesApi.super.deletePackage(packageId);
    }

    @Override
    public ResponseEntity<PackageDto> getPackageById(Integer packageId) {
        return PackagesApi.super.getPackageById(packageId);
    }

    @Override
    public ResponseEntity<GetPackages200Response> getPackages(GetAccountsPageableParameter pageable, String filter) {
        return PackagesApi.super.getPackages(pageable, filter);
    }

    @Override
    public ResponseEntity<PackageDto> updatePackage(Integer packageId, PackageDto packageDto) {
        return PackagesApi.super.updatePackage(packageId, packageDto);
    }
}