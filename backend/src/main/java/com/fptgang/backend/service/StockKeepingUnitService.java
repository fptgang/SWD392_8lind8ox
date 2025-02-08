package com.fptgang.backend.service;

import com.fptgang.backend.model.StockKeepingUnit;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface StockKeepingUnitService {
    StockKeepingUnit create(StockKeepingUnit sku);

    StockKeepingUnit findById(long id);

    StockKeepingUnit update(StockKeepingUnit sku);

    StockKeepingUnit deleteById(long id);

    Page<StockKeepingUnit> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);

    default Page<StockKeepingUnit> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }

    default Page<StockKeepingUnit> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}