package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.CategoriesApi;
import com.fptgang.backend.api.model.*;
import com.fptgang.backend.mapper.CategoryMapper;
import com.fptgang.backend.model.Role;
import com.fptgang.backend.service.CategoryService;
import com.fptgang.backend.util.OpenApiHelper;
import com.fptgang.backend.util.SecurityUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.NativeWebRequest;

import java.util.Optional;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class CategoryController implements CategoriesApi{

    private final CategoryService categoryService;
    private final CategoryMapper categoryMapper;

    public CategoryController(CategoryService categoryService, CategoryMapper categoryMapper) {
        this.categoryService = categoryService;
        this.categoryMapper = categoryMapper;
    }

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return CategoriesApi.super.getRequest();
    }

    @Override
    public ResponseEntity<CategoryDto> createCategory(CategoryDto categoryDto) {
        log.info("Creating category");
        ResponseEntity<CategoryDto> response = new ResponseEntity<>(categoryMapper
                .toDTO(categoryService.create(categoryMapper.toEntity(categoryDto))), HttpStatus.CREATED);
        return response;
    }

    @Override
    public ResponseEntity<Void> deleteCategory(Integer categoryId) {
        log.info("Deleting category " + categoryId);
        categoryService.deleteById(Long.valueOf(categoryId));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Override
    public ResponseEntity<CategoryDto> getCategoryById(Integer categoryId) {
        log.info("Getting category by id " + categoryId);
        return new ResponseEntity<>(categoryMapper.toDTO(categoryService.findById(Long.valueOf(categoryId))), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<GetCategories200Response> getCategories(Pageable pageable, String filter, String search) {
        log.info("Getting categories");
        var page = OpenApiHelper.toPageable(pageable);
        var includeInvisible = SecurityUtil.hasPermission(Role.ADMIN);
        var res = categoryService.getAll(page, filter, search, includeInvisible).map(categoryMapper::toDTO);
        return OpenApiHelper.respondPage(res, GetCategories200Response.class);
    }

    @Override
    public ResponseEntity<CategoryDto> updateCategory(Integer categoryId, CategoryDto categoryDto) {
        log.info("Updating category " + categoryId);
        return ResponseEntity.ok(categoryMapper.toDTO(categoryService.update(categoryMapper.toEntity(categoryDto))));
    }
}
