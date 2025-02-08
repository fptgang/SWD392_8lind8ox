package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.repository.StockKeepingUnitRepos;
import com.fptgang.backend.service.StockKeepingUnitService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class StockKeepingUnitServiceImpl implements StockKeepingUnitService {

    private final StockKeepingUnitRepos skuRepos;

    @Autowired
    public StockKeepingUnitServiceImpl(StockKeepingUnitRepos skuRepos) {
        this.skuRepos = skuRepos;
    }

    @Override
    public StockKeepingUnit create(StockKeepingUnit sku) {
        return skuRepos.save(sku);
    }

    @Override
    public StockKeepingUnit findById(long id) {
        return skuRepos.findById(id).orElse(null);
    }

    @Override
    public StockKeepingUnit update(StockKeepingUnit sku) {
        if (sku.getSkuId() == null) {
            throw new IllegalArgumentException("StockKeepingUnitage does not exist");
        }
        return skuRepos.save(sku);
    }

    @Override
    public StockKeepingUnit deleteById(long id) {
        StockKeepingUnit sku = skuRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("StockKeepingUnitage does not exist"));
//        sku.skuVisible(false);
        return skuRepos.save(sku);
    }

    @Override
    public Page<StockKeepingUnit> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<StockKeepingUnit>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return skuRepos.findAll(spec, pageable);
    }
}