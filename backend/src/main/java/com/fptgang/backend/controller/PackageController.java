package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.PackagesApi;
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
    public ResponseEntity<GetPackages200Response> getPackages(Pageable pageable, String filter, String search) {
        log.info("Getting packages");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        return OpenApiHelper.respondPage(null, GetPackages200Response.class);
    }

    @Override
    public ResponseEntity<PackageDto> updatePackage(Integer packageId, PackageDto packageDto) {
        return PackagesApi.super.updatePackage(packageId, packageDto);
    }
}