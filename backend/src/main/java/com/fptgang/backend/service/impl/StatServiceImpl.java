package com.fptgang.backend.service.impl;

import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.OrderDetailRepos;
import com.fptgang.backend.repository.OrderRepos;
import com.fptgang.backend.repository.OrderStatusHistoryRepos;
import com.fptgang.backend.service.StatService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class StatServiceImpl implements StatService {


    private final OrderRepos orderRepos;
    private final AccountRepos accountRepos;
    private final OrderStatusHistoryRepos orderStatusHistoryRepos;
    private final OrderDetailRepos orderDetailRepos;
    public StatServiceImpl(OrderRepos orderRepos, AccountRepos accountRepos, OrderStatusHistoryRepos orderStatusHistoryRepos, OrderDetailRepos orderDetailRepos) {
        this.orderRepos = orderRepos;
        this.accountRepos = accountRepos;
        this.orderStatusHistoryRepos = orderStatusHistoryRepos;
        this.orderDetailRepos = orderDetailRepos;
    }

    @Override
    public List<Map<String, Object>> getDailyOrders() {
        return orderRepos.getDailyOrders().stream()
                .map(entry -> Map.of(
                        "x", (Object) entry[0].toString(),
                        "y", (Object) ((Number) entry[1]).intValue() // Convert to Integer
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getDailyRevenue() {
        return orderRepos.getDailyRevenue().stream()
                .map(entry -> Map.of(
                        "x", (Object) entry[0].toString(),
                        "y", (Object) ((Number) entry[1]).doubleValue() // Convert to Double
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getMonthlyRevenue() {
        return orderRepos.getMonthlyRevenue().stream()
                .map(entry -> Map.of(
                        "x", (Object) entry[0].toString(),
                        "y", (Object) ((Number) entry[1]).doubleValue()
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getDailyNewCustomers() {
        return accountRepos.getDailyNewCustomers().stream()
                .map(entry -> Map.<String, Object>of( // Explicit type specification
                        "x", entry[0] != null ? entry[0].toString() : "Unknown Date", // Ensure x-axis (date) is a String
                        "y", entry[1] != null ? ((Number) entry[1]).intValue() : 0  // Convert count to Integer, default to 0
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getMonthlyNewCustomers() {
        return accountRepos.getMonthlyNewCustomers().stream()
                .map(entry -> Map.<String, Object>of( // Explicit type specification
                        "x", entry[0] != null ? entry[0].toString() : "Unknown Month", // Ensure month is a String
                        "y", entry[1] != null ? ((Number) entry[1]).intValue() : 0  // Convert count to Integer, default to 0
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getDailyFulfillmentTime() {
        return orderStatusHistoryRepos.getDailyFulfillmentTime().stream()
                .map(entry -> Map.<String, Object>of(  // Explicitly define <String, Object>
                        "x", entry[0] != null ? (Object) entry[0].toString() : "Unknown Date",
                        "y", entry[1] instanceof Number ? ((Number) entry[1]).doubleValue() : 0.0
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getTopBrands(String startDate, String endDate, int limit) {
        return orderDetailRepos.getTopBrands(startDate, endDate).stream()
                .limit(limit) // Apply limit here
                .map(entry -> Map.<String, Object>of(
                        "brand", entry[0] != null ? entry[0].toString() : "Unknown Brand",
                        "purchases", entry[1] instanceof Number ? ((Number) entry[1]).intValue() : 0
                ))
                .collect(Collectors.toList());
    }


    @Override
    public List<Map<String, Object>> getRevenueBySKU(String startDate, String endDate) {
        return orderDetailRepos.getRevenueBySKU(startDate, endDate).stream()
                .map(entry -> Map.<String, Object>of(
                        "sku", entry[0] != null ? entry[0].toString() : "Unknown SKU",
                        "revenue", entry[1] != null ? ((Number) entry[1]).doubleValue() : 0.0
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getRevenueByBlindBox(String startDate, String endDate) {
        return orderDetailRepos.getRevenueByBlindBox(startDate, endDate).stream()
                .map(entry -> Map.<String, Object>of(
                        "blindBox", entry[0] != null ? entry[0].toString() : "Unknown BlindBox",
                        "revenue", entry[1] != null ? ((Number) entry[1]).doubleValue() : 0.0
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getRevenueByBrand(String startDate, String endDate) {
        return orderDetailRepos.getRevenueByBrand(startDate, endDate).stream()
                .map(entry -> Map.<String, Object>of(
                        "brand", entry[0] != null ? entry[0].toString() : "Unknown Brand",
                        "revenue", entry[1] != null ? ((Number) entry[1]).doubleValue() : 0.0
                ))
                .collect(Collectors.toList());
    }

    @Override
    public List<Map<String, Object>> getRevenueTrend(String startDate, String endDate, String groupBy) {
        return orderRepos.getRevenueTrend(startDate, endDate, groupBy).stream()
                .map(entry -> Map.<String, Object>of(
                        "period", entry[0] != null ? entry[0].toString() : "Unknown Period",
                        "revenue", entry[1] != null ? ((Number) entry[1]).doubleValue() : 0.0
                ))
                .collect(Collectors.toList());
    }

}

