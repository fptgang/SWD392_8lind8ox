package com.fptgang.backend.model.sales;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TrendingProduct {
    private Long brandId;
    private String brandName;
    private Long blindBoxId;
    private String blindBoxName;
    private Long skuId;
    private String skuName;
    private BigDecimal price;
    private Long orderCount;
    private String image;
}