package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.model.Toy;
import com.fptgang.backend.repository.ToyRepos;
import com.fptgang.backend.service.ToyService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ToyServiceImpl implements ToyService {

    private final ToyRepos toyRepos;

    @Autowired
    public ToyServiceImpl(ToyRepos toyRepos) {
        this.toyRepos = toyRepos;
    }

    @Override
    public Toy create(Toy toy) {
        return toyRepos.save(toy);
    }

    @Override
    public Toy findById(long id) {
        return toyRepos.findById(id).orElse(null);
    }

    @Override
    public Toy update(Toy toy) {
        Toy existing = toyRepos.findById(toy.getToyId())
                .orElseThrow(() -> new IllegalArgumentException("Toy does not exist"));
        EntityUtil.merge(existing, toy);
        return toyRepos.save(existing);
    }

    @Override
    public Toy deleteById(long id) {
        Toy toy = toyRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Toy does not exist"));
//        toy.setIsVisible(false);
        return toyRepos.save(toy);
    }

    @Override
    public Page<Toy> getAll(ListParams params) {
        var spec = params.<Toy>toSpec();
        return toyRepos.findAll(spec, params.getPageable());
    }
}