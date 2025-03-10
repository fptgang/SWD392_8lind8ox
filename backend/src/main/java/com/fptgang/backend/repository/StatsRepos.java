package com.fptgang.backend.repository;

import com.fptgang.backend.model.stats.StringBigDecimalDatapoint;

import java.time.LocalDateTime;
import java.util.List;

public interface StatsRepos {
    List<StringBigDecimalDatapoint> getRevenueBySKU(LocalDateTime startDate, LocalDateTime endDate);
}
