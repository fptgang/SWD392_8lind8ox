package com.fptgang.backend.controller;

import com.fptgang.backend.api.controller.StatsApi;
import com.fptgang.backend.api.model.StringBigDecimalDatapointDto;
import com.fptgang.backend.api.model.StringIntegerDatapointDto;
import com.fptgang.backend.mapper.DetailLevel;
import com.fptgang.backend.mapper.stats.StringBigDecimalDatapointMapper;
import com.fptgang.backend.mapper.stats.StringIntegerDatapointMapper;
import com.fptgang.backend.service.StatService;
import com.fptgang.backend.util.DateTimeUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.OffsetDateTime;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/v1/stats")
public class StatController implements StatsApi {

    private final StatService statService;
    private final StringBigDecimalDatapointMapper stringBigDecimalDatapointMapper;
    private final StringIntegerDatapointMapper stringIntegerDatapointMapper;

    public StatController(StatService statService, StringBigDecimalDatapointMapper stringBigDecimalDatapointMapper, StringIntegerDatapointMapper stringIntegerDatapointMapper) {
        this.statService = statService;
        this.stringBigDecimalDatapointMapper = stringBigDecimalDatapointMapper;
        this.stringIntegerDatapointMapper = stringIntegerDatapointMapper;
    }

    /**
     * Get daily order count as time-series data
     * @return List of time-series data [{x: date, y: orderCount}]
     */
    @Override
    @GetMapping("/daily-order")
    public ResponseEntity<List<StringIntegerDatapointDto>> getDailyOrders() {
        var data = statService.getDailyOrders();
        var result = data.stream().map(d -> stringIntegerDatapointMapper.toDTO(d, DetailLevel.FULL)).toList();
        return ResponseEntity.ok(result);
    }

    /**
     * Get daily revenue as time-series data
     * @return List of time-series data [{x: date, y: totalRevenue}]
     */
    @Override
    @GetMapping("/daily-revenue")
    public ResponseEntity<List<StringBigDecimalDatapointDto>> getDailyRevenue() {
        var data = statService.getDailyRevenue();
        var result = data.stream().map(d -> stringBigDecimalDatapointMapper.toDTO(d, DetailLevel.FULL)).toList();
        return ResponseEntity.ok(result);
    }

    /**
     * Get monthly revenue as time-series data
     * @return List of time-series data [{x: yyyy-MM, y: totalRevenue}]
     */
    @Override
    @GetMapping("/monthly-revenue")
    public ResponseEntity<List<StringBigDecimalDatapointDto>> getMonthlyRevenue() {
        var data = statService.getMonthlyRevenue();
        var result = data.stream().map(d -> stringBigDecimalDatapointMapper.toDTO(d, DetailLevel.FULL)).toList();
        return ResponseEntity.ok(result);
    }

    @Override
    @GetMapping("/revenue-by-sku")
    public ResponseEntity<List<StringBigDecimalDatapointDto>> revenueBySku(
            @RequestParam("start-date") OffsetDateTime startDate,
            @RequestParam("end-date") OffsetDateTime endDate) {
        var data = statService.getRevenueBySKU(
                DateTimeUtil.fromOffsetToLocal(startDate),
                DateTimeUtil.fromOffsetToLocal(endDate)
        );
        return ResponseEntity.ok(
                data.stream().map(d -> stringBigDecimalDatapointMapper.toDTO(d, DetailLevel.FULL)).toList()
        );
    }

    @Override
    @GetMapping("/revenue-by-blind-box")
    public ResponseEntity<List<StringBigDecimalDatapointDto>> getRevenueByBlindBox(
            @RequestParam("start-date") OffsetDateTime startDate,
            @RequestParam("end-date") OffsetDateTime endDate) {
        var data = statService.getRevenueByBlindBox(DateTimeUtil.fromOffsetToLocal(startDate), DateTimeUtil.fromOffsetToLocal(endDate));
        var result = data.stream().map(d -> stringBigDecimalDatapointMapper.toDTO(d, DetailLevel.FULL)).toList();
        return ResponseEntity.ok(result);
    }

    @Override
    @GetMapping("/revenue-by-brand")
    public ResponseEntity<List<StringBigDecimalDatapointDto>> getRevenueByBrand(
            @RequestParam("start-date") OffsetDateTime startDate,
            @RequestParam("end-date") OffsetDateTime endDate) {
        var data = statService.getRevenueByBrand(DateTimeUtil.fromOffsetToLocal(startDate), DateTimeUtil.fromOffsetToLocal(endDate));
        var result = data.stream().map(d -> stringBigDecimalDatapointMapper.toDTO(d, DetailLevel.FULL)).toList();
        return ResponseEntity.ok(result);
    }

    @Override
    @GetMapping("/top-selling-skus")
    public ResponseEntity<List<StringIntegerDatapointDto>> getTopSellingSKUs(
            @RequestParam("start-date") OffsetDateTime startDate,
            @RequestParam("end-date") OffsetDateTime endDate,
            @RequestParam Integer limit) {
        var data = statService.getTopSellingSKUs(DateTimeUtil.fromOffsetToLocal(startDate), DateTimeUtil.fromOffsetToLocal(endDate), limit);
        var result = data.stream().map(d -> stringIntegerDatapointMapper.toDTO(d, DetailLevel.FULL)).toList();
        return ResponseEntity.ok(result);
    }
}
