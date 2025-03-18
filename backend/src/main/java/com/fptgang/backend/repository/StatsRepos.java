package com.fptgang.backend.repository;

import com.fptgang.backend.model.stats.StringBigDecimalDatapoint;
import com.fptgang.backend.model.stats.StringIntegerDatapoint;

import java.time.LocalDateTime;
import java.util.List;

public interface StatsRepos {
    List<StringBigDecimalDatapoint> getRevenueBySKU(LocalDateTime startDate, LocalDateTime endDate);
    List<StringIntegerDatapoint> getDailyOrders();
    List<StringBigDecimalDatapoint> getDailyRevenue();
    List<StringBigDecimalDatapoint> getMonthlyRevenue();
    List<StringBigDecimalDatapoint> getRevenueByBlindBox(LocalDateTime startDate, LocalDateTime endDate);
    List<StringBigDecimalDatapoint> getRevenueByBrand(LocalDateTime startDate, LocalDateTime endDate);
    List<StringIntegerDatapoint> getTopSellingSKUs(LocalDateTime startDate, LocalDateTime endDate, int limit);
}
