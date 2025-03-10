package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.stats.StringBigDecimalDatapoint;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderDetailRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.repository.StatsRepos;
import com.fptgang.backend.service.StatService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class StatServiceImpl implements StatService {
    private final OrderRepos orderRepos;
    private final AccountRepos accountRepos;
    private final OrderDetailRepos orderDetailRepos;
    private final StatsRepos statsRepos;

    public StatServiceImpl(OrderRepos orderRepos, AccountRepos accountRepos, OrderDetailRepos orderDetailRepos, StatsRepos statsRepos) {
        this.orderRepos = orderRepos;
        this.accountRepos = accountRepos;
        this.orderDetailRepos = orderDetailRepos;
        this.statsRepos = statsRepos;
    }

    @Override
    public List<Map<String, Object>> getDailyOrders() {
        return orderRepos.getDailyOrders().stream()
                .map( entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("x", entry[0] != null ? entry[0].toString() : "Unknown Date");
                    map.put("y", entry[1] instanceof Number ? ((Number) entry[1]).intValue() : 0);
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getDailyRevenue() {
        return orderRepos.getDailyRevenue().stream()
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("x", entry[0] != null ? entry[0].toString() : "Unknown Date");
                    map.put("y", entry[1] instanceof Number ? ((Number) entry[1]).doubleValue() : 0.0);
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getMonthlyRevenue() {
        return orderRepos.getMonthlyRevenue().stream()
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("x", entry[0] != null ? entry[0].toString() : "Unknown Month");
                    map.put("y", entry[1] instanceof Number ? ((Number) entry[1]).doubleValue() : 0.0);
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getDailyNewCustomers() {
        return accountRepos.getDailyNewCustomers().stream()
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("x", entry[0] != null ? entry[0].toString() : "Unknown Date");
                    map.put("y", entry[1] instanceof Number ? ((Number) entry[1]).intValue() : 0);
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getMonthlyNewCustomers() {
        return accountRepos.getMonthlyNewCustomers().stream()
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("x", entry[0] != null ? entry[0].toString() : "Unknown Month");
                    map.put("y", entry[1] instanceof Number ? ((Number) entry[1]).intValue() : 0);
                    return map;
                })
                .collect(Collectors.toList());
    }


    @Override
    public List<Map<String, Object>> getTopBrands(LocalDateTime startDate, LocalDateTime endDate, int limit) {
        return orderDetailRepos.getTopBrands(startDate, endDate).stream()
                .limit(limit)
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("brand", entry[0] != null ? entry[0].toString() : "Unknown Brand");
                    map.put("purchases", entry[1] instanceof Number ? ((Number) entry[1]).intValue() : 0);
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueBySKU(LocalDateTime startDate, LocalDateTime endDate) {
        return statsRepos.getRevenueBySKU(startDate, endDate);
    }

    @Override
    public List<Map<String, Object>> getRevenueByBlindBox(LocalDateTime startDate, LocalDateTime endDate) {
        return orderDetailRepos.getRevenueByBlindBox(startDate, endDate).stream()
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("blindBox", entry[0] != null ? entry[0].toString() : "Unknown BlindBox");
                    map.put("revenue", entry[1] instanceof Number ? ((Number) entry[1]).doubleValue() : 0.0);
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getRevenueByBrand(LocalDateTime startDate, LocalDateTime endDate) {
        return orderDetailRepos.getRevenueByBrand(startDate, endDate).stream()
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("brand", entry[0] != null ? entry[0].toString() : "Unknown Brand");
                    map.put("revenue", entry[1] instanceof Number ? ((Number) entry[1]).doubleValue() : 0.0);
                    return map;
                })
                .collect(Collectors.toList());
    }


    @Override
    public List<Map<String, Object>> getRevenueTrend(LocalDateTime startDate, LocalDateTime endDate, String groupBy) {
        return orderRepos.getRevenueTrend(startDate, endDate, groupBy).stream()
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("period", entry[0] != null ? entry[0].toString() : "Unknown Period");
                    map.put("revenue", entry[1] instanceof Number ? ((Number) entry[1]).doubleValue() : 0.0);
                    return map;
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getTopSellingSKUs(LocalDateTime startDate, LocalDateTime endDate, int limit) {
        return orderDetailRepos.getTopSellingSKUs(startDate, endDate, limit).stream()
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("sku", entry[0] != null ? entry[0].toString() : "Unknown SKU");
                    map.put("quantitySold", entry[1] instanceof Number ? ((Number) entry[1]).intValue() : 0);
                    return map;
                })
                .collect(Collectors.toList());
    }

}

