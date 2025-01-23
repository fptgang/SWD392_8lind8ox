package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Brand;
import com.fptgang.backend.repository.CategoryRepos;
import com.fptgang.backend.service.CategoryService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepos categoryRepos;

    @Autowired
    public CategoryServiceImpl(CategoryRepos categoryRepos) {
        this.categoryRepos = categoryRepos;
    }

    @Override
    public Brand create(Brand brand) {
        return categoryRepos.save(brand);
    }

    @Override
    public Brand findById(long id) {
        return categoryRepos.findById(id).orElse(null);
    }

    @Override
    public Brand update(Brand brand) {
        if (brand.getBrandId() == null) {
            throw new IllegalArgumentException("Category does not exist");
        }
        return categoryRepos.save(brand);
    }

    @Override
    public Brand deleteById(long id) {
        Brand brand = categoryRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Category does not exist"));
        brand.setVisible(false);
        return categoryRepos.save(brand);
    }

    @Override
    public Page<Brand> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Brand>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return categoryRepos.findAll(spec, pageable);
    }
}