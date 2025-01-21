package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Category;
import com.fptgang.backend.repository.CategoryRepos;
import com.fptgang.backend.service.CategoryService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryServiceImpl implements CategoryService {
    private static final List<String> WHITELIST_PATHS =
            List.of("categoryId", "name", "description", "createdAt", "updatedAt");

    private final CategoryRepos categoryRepos;

    @Autowired
    public CategoryServiceImpl(CategoryRepos categoryRepos) {
        this.categoryRepos = categoryRepos;
    }

    @Override
    public Category create(Category category) {
        return categoryRepos.save(category);
    }

    @Override
    public Category findById(long id) {
        return categoryRepos.findById(id).orElse(null);
    }

    @Override
    public Category update(Category category) {
        if (category.getCategoryId() == null) {
            throw new IllegalArgumentException("Category does not exist");
        }
        return categoryRepos.save(category);
    }

    @Override
    public Category deleteById(long id) {
        Category category = categoryRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Category does not exist"));
        category.setVisible(false);
        return categoryRepos.save(category);
    }

    @Override
    public Page<Category> getAll(Pageable pageable, String filter, boolean includeInvisible) {
        var spec = OpenApiHelper.<Category>toSpecification(filter, WHITELIST_PATHS);
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return categoryRepos.findAll(spec, pageable);
    }
}