package com.fptgang.backend.service;

import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface StockKeepingUnitService {
    StockKeepingUnit create(StockKeepingUnit sku);

    StockKeepingUnit findById(long id);

    StockKeepingUnit update(StockKeepingUnit sku);

    StockKeepingUnit deleteById(long id);

    Page<StockKeepingUnit> getAll(ListParams params);
}