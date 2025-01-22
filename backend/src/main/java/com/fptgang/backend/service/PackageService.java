package com.fptgang.backend.service;

import com.fptgang.backend.model.Package;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface PackageService {
    Package create(Package package_);
    Package findById(long id);
    Package update(Package package_);
    Package deleteById(long id);
    Page<Package> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);
    default Page<Package> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }
    default Page<Package> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}