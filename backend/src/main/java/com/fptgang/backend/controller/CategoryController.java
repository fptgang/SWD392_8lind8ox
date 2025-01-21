package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.AccountsApi;
import com.fptgang.backend.api.controller.CategoriesApi;
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
public class CategoryController implements CategoriesApi{

    @Override
    public Optional<NativeWebRequest> getRequest() {
        return CategoriesApi.super.getRequest();
    }

    @Override
    public ResponseEntity<CategoryDto> createCategory(CategoryDto categoryDto) {
        return CategoriesApi.super.createCategory(categoryDto);
    }

    @Override
    public ResponseEntity<Void> deleteCategory(Integer categoryId) {
        return CategoriesApi.super.deleteCategory(categoryId);
    }

    @Override
    public ResponseEntity<GetCategories200Response> getCategories(GetAccountsPageableParameter pageable, String filter) {
        return CategoriesApi.super.getCategories(pageable, filter);
    }

    @Override
    public ResponseEntity<CategoryDto> getCategoryById(Integer categoryId) {
        return CategoriesApi.super.getCategoryById(categoryId);
    }

    @Override
    public ResponseEntity<CategoryDto> updateCategory(Integer categoryId, CategoryDto categoryDto) {
        return CategoriesApi.super.updateCategory(categoryId, categoryDto);
    }
}
