package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.repository.StockKeepingUnitRepos;
import com.fptgang.backend.service.StockKeepingUnitService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
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
        sku.setSkuId(null);
        if(sku.getIsVisible() == null) {
            sku.setIsVisible(false);
        }
        return skuRepos.save(sku);
    }

    @Override
    public StockKeepingUnit findById(long id) {
        return skuRepos.findById(id).orElse(null);
    }

    @Override
    public StockKeepingUnit update(StockKeepingUnit sku) {
        StockKeepingUnit existing = skuRepos.findById(sku.getSkuId())
                .orElseThrow(() -> new IllegalArgumentException("StockKeepingUnit does not exist"));
        EntityUtil.merge(existing, sku);
        return skuRepos.save(existing);
    }

    @Override
    public StockKeepingUnit deleteById(long id) {
        StockKeepingUnit sku = skuRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("StockKeepingUnit does not exist"));
//        sku.skuVisible(false);
        return skuRepos.save(sku);
    }

    @Override
    public Page<StockKeepingUnit> getAll(ListParams params) {
        var spec = params.<StockKeepingUnit>toSpec();
        return skuRepos.findAll(spec, params.getPageable());
    }
}