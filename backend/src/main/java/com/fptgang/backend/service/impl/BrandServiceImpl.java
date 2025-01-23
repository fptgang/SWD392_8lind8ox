package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Brand;
import com.fptgang.backend.repository.BrandRepos;
import com.fptgang.backend.service.BrandService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class BrandServiceImpl implements BrandService {

    private final BrandRepos brandRepos;

    @Autowired
    public BrandServiceImpl(BrandRepos brandRepos) {
        this.brandRepos = brandRepos;
    }

    @Override
    public Brand create(Brand brand) {
        return brandRepos.save(brand);
    }

    @Override
    public Brand findById(long id) {
        return brandRepos.findById(id).orElse(null);
    }

    @Override
    public Brand update(Brand brand) {
        if (brand.getBrandId() == null) {
            throw new IllegalArgumentException("Brand does not exist");
        }
        return brandRepos.save(brand);
    }

    @Override
    public Brand deleteById(long id) {
        Brand brand = brandRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Brand does not exist"));
        brand.setVisible(false);
        return brandRepos.save(brand);
    }

    @Override
    public Page<Brand> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Brand>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return brandRepos.findAll(spec, pageable);
    }
}