package com.fptgang.backend.service;

import com.fptgang.backend.model.sales.TrendingProduct;

import java.util.List;

public interface SalesService {
    // Get Top-selling Products within the last "interval" days
    List<TrendingProduct> getTrendingProducts(int interval);
}
