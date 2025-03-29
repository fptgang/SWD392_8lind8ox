package com.fptgang.backend.service;

import com.fptgang.backend.model.BlindBox;
import com.fptgang.backend.model.sales.TrendingProduct;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

import java.util.List;

public interface SalesService {
    // Get Top-selling Products within the last "interval" days
    List<TrendingProduct> getTrendingProducts(int interval);
    Page<BlindBox> getAllHotSales(ListParams params);
}
