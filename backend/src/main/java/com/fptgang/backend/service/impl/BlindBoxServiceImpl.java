package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.BlindBox;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.service.BlindBoxService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class BlindBoxServiceImpl implements BlindBoxService {

    private final BlindBoxRepos blindBoxRepos;

    @Autowired
    public BlindBoxServiceImpl(BlindBoxRepos blindBoxRepos) {
        this.blindBoxRepos = blindBoxRepos;
    }

    @Override
    public BlindBox create(BlindBox blindBox) {
        return blindBoxRepos.save(blindBox);
    }

    @Override
    public BlindBox findById(long id) {
        return blindBoxRepos.findById(id).orElse(null);
    }

    @Override
    public BlindBox update(BlindBox blindBox) {
        if (blindBox.getBlindBoxId() == null) {
            throw new IllegalArgumentException("BlindBox does not exist");
        }
        return blindBoxRepos.save(blindBox);
    }

    @Override
    public BlindBox deleteById(long id) {
        BlindBox blindBox = blindBoxRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("BlindBox does not exist"));
        blindBox.setVisible(false);
        return blindBoxRepos.save(blindBox);
    }

    @Override
    public Page<BlindBox> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<BlindBox>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return blindBoxRepos.findAll(spec, pageable);
    }
}