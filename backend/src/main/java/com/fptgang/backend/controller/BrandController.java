package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.BrandsApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.BrandMapper;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.service.BrandService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
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
public class BrandController implements BrandsApi{

    private final BrandService brandService;
    private final BrandMapper brandMapper;

    public BrandController(BrandService brandService, BrandMapper brandMapper) {
        this.brandService = brandService;
        this.brandMapper = brandMapper;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return BrandsApi.super.getRequest();
    }

    @Override
    public ResponseEntity<BrandDto> createBrand(BrandDto brandDto) {
        if (!SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can create brands.");
        }
        log.info("Creating brand");
        ResponseEntity<BrandDto> response = new ResponseEntity<>(brandMapper
                .toDTO(brandService.create(brandMapper.toEntity(brandDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deleteBrand(Long brandId) {
        log.info("Deleting brand " + brandId);
        if (!SecurityUtil.hasPermission(Account.Role.ADMIN)) {
            throw new AccessDeniedException("Only admins can delete brands.");
        }
        brandService.deleteById(brandId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<BrandDto> getBrandById(Long brandId) {
        log.info("Getting brand by id " + brandId);
        return new ResponseEntity<>(brandMapper.toDTO(brandService.findById(brandId)), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetBrands200Response> getBrands(Pageable pageable, String filter, String search) {
        log.info("Getting brands");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = false;
        try{
             includeInvisible = SecurityUtil.hasPermission(Account.Role.ADMIN);
        }catch (Exception e){
            log.error("Error getting permission {}", e.getMessage());
        }

        var res = brandService.getAll(page, filter, search, includeInvisible).map(brandMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetBrands200Response.class);
    }

    @Override
    public ResponseEntity<BrandDto> updateBrand(Long brandId, BrandDto brandDto) {
        if (!SecurityUtil.isRole(Account.Role.ADMIN, Account.Role.STAFF)) {
            throw new AccessDeniedException("Only staff and admins can update brands.");
        }
        brandDto.setBrandId(brandId); // Override brandId

        log.info("Updating brand " + brandId);
        return ResponseEntity.ok(brandMapper.toDTO(brandService.update(brandMapper.toEntity(brandDto))));
    }
}
