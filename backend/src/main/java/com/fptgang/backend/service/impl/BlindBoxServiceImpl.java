package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.BlindBox;
import com.fptgang.backend.repository.BlindBoxRepos;
import com.fptgang.backend.service.BlindBoxService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
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
        if(blindBox.getSkus() != null && !blindBox.getSkus().isEmpty()) {
            blindBox.getSkus().forEach(sku -> sku.setBlindBox(blindBox));
        }
        return blindBoxRepos.save(blindBox);
    }

    @Override
    public BlindBox findById(long id) {
        return blindBoxRepos.findById(id).orElse(null);
    }

    @Override
    public BlindBox update(BlindBox blindBox) {
        BlindBox existing = blindBoxRepos.findById(blindBox.getBlindBoxId())
                .orElseThrow(() -> new IllegalArgumentException("BlindBox does not exist"));
        EntityUtil.merge(existing, blindBox);
        return blindBoxRepos.save(existing);
    }

    @Override
    public BlindBox deleteById(long id) {
        BlindBox blindBox = blindBoxRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("BlindBox does not exist"));
        blindBox.setIsVisible(false);
        return blindBoxRepos.save(blindBox);
    }

    @Override
    public Page<BlindBox> getAll(ListParams params) {
        var spec = params.<BlindBox>toSpec();
        return blindBoxRepos.findAll(spec, params.getPageable());
    }
}