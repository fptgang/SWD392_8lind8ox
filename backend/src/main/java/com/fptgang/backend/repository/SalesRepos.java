package com.fptgang.backend.repository;

import com.fptgang.backend.model.sales.TrendingProduct;

import java.util.List;

public interface SalesRepos {
    List<TrendingProduct> findBlindBoxSales(int days);
}
