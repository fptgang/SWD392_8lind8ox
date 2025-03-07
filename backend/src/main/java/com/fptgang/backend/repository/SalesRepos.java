package com.fptgang.backend.repository;

import com.fptgang.backend.model.sales.TrendingProduct;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SalesRepos {
    List<TrendingProduct> findBlindBoxSales(@Param("days") int days);
}
