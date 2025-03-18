package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.stats.StringBigDecimalDatapoint;
import com.fptgang.backend.model.stats.StringIntegerDatapoint;
import com.fptgang.backend.repository.StatsRepos;
import com.fptgang.backend.service.StatService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class StatServiceImpl implements StatService {

    private final StatsRepos statsRepos;

    public StatServiceImpl(StatsRepos statsRepos) {
        this.statsRepos = statsRepos;
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueBySKU(LocalDateTime startDate, LocalDateTime endDate) {
        return statsRepos.getRevenueBySKU(startDate, endDate);
    }

    @Override
    public List<StringIntegerDatapoint> getDailyOrders() {
        return statsRepos.getDailyOrders();
    }

    @Override
    public List<StringBigDecimalDatapoint> getDailyRevenue() {
        return statsRepos.getDailyRevenue();
    }

    @Override
    public List<StringBigDecimalDatapoint> getMonthlyRevenue() {
        return statsRepos.getMonthlyRevenue();
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueByBlindBox(LocalDateTime startDate, LocalDateTime endDate) {
        return statsRepos.getRevenueByBlindBox(startDate, endDate);
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueByBrand(LocalDateTime startDate, LocalDateTime endDate) {
        return statsRepos.getRevenueByBrand(startDate, endDate);
    }

    @Override
    public List<StringIntegerDatapoint> getTopSellingSKUs(LocalDateTime startDate, LocalDateTime endDate, int limit) {
        return statsRepos.getTopSellingSKUs(startDate, endDate, limit);
    }
}

