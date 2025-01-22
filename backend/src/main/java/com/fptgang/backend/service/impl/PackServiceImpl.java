package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Pack;
import com.fptgang.backend.repository.PackRepos;
import com.fptgang.backend.service.PackService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class PackServiceImpl implements PackService {

    private final PackRepos packRepos;

    @Autowired
    public PackServiceImpl(PackRepos packRepos) {
        this.packRepos = packRepos;
    }

    @Override
    public Pack create(Pack pack) {
        return packRepos.save(pack);
    }

    @Override
    public Pack findById(long id) {
        return packRepos.findById(id).orElse(null);
    }

    @Override
    public Pack update(Pack pack) {
        if (pack.getPackId() == null) {
            throw new IllegalArgumentException("Package does not exist");
        }
        return packRepos.save(pack);
    }

    @Override
    public Pack deleteById(long id) {
        Pack pack = packRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Package does not exist"));
        pack.setVisible(false);
        return packRepos.save(pack);
    }

    @Override
    public Page<Pack> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Pack>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return packRepos.findAll(spec, pageable);
    }
}