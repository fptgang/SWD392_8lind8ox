package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.SalesApi;
import com.fptgang.backend.api.model.TrendingProductDto;
import com.fptgang.backend.exception.InvalidInputException;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.sales.TrendingProductMapper;
import com.fptgang.backend.service.SalesService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/v1")
public class SalesController implements SalesApi {
    private final TrendingProductMapper trendingProductMapper;
    private final SalesService salesService;

    public SalesController(TrendingProductMapper trendingProductMapper,
                           SalesService salesService) {
        this.trendingProductMapper = trendingProductMapper;
        this.salesService = salesService;
    }

    @Override
    public ResponseEntity<List<TrendingProductDto>> getTrendingProducts(String interval) {
        var days = switch (interval) {
            case "DAY" -> 1;
            case "WEEK" -> 7;
            case "MONTH" -> 30;
            default ->
                throw new InvalidInputException("Expect: DAY/WEEK/MONTH");
        };
        var proj = salesService.getTrendingProducts(days);
        return ResponseEntity.ok(
                proj.stream().map(e -> {
                    return trendingProductMapper.toDTO(e, DetailLevel.FULL);
                }).toList()
        );
    }
}
