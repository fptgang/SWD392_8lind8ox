package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Package;
import com.fptgang.backend.repository.PackageRepos;
import com.fptgang.backend.service.PackageService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PackageServiceImpl implements PackageService {
    private static final List<String> WHITELIST_PATHS =
            List.of("packageId", "name", "description", "quantity", "price", "createdAt", "updatedAt");

    private final PackageRepos packageRepos;

    @Autowired
    public PackageServiceImpl(PackageRepos packageRepos) {
        this.packageRepos = packageRepos;
    }

    @Override
    public Package create(Package package_) {
        return packageRepos.save(package_);
    }

    @Override
    public Package findById(long id) {
        return packageRepos.findById(id).orElse(null);
    }

    @Override
    public Package update(Package package_) {
        if (package_.getPackageId() == null) {
            throw new IllegalArgumentException("Package does not exist");
        }
        return packageRepos.save(package_);
    }

    @Override
    public Package deleteById(long id) {
        Package package_ = packageRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Package does not exist"));
        package_.setVisible(false);
        return packageRepos.save(package_);
    }

    @Override
    public Page<Package> getAll(Pageable pageable, String filter, boolean includeInvisible) {
        var spec = OpenApiHelper.<Package>toSpecification(filter, WHITELIST_PATHS);
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return packageRepos.findAll(spec, pageable);
    }
}