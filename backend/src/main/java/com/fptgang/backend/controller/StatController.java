package com.fptgang.backend.controller;

import com.fptgang.backend.service.StatService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/v1/stats")
public class StatController {

    private final StatService statService;

    public StatController(StatService statService) {
        this.statService = statService;
    }

    /**
     * Get daily order count as time-series data
     * @return List of time-series data [{x: date, y: orderCount}]
     */
    @GetMapping("/daily-orders")
    public ResponseEntity<List<Map<String, Object>>> getDailyOrders() {
        log.info("Fetching daily order statistics...");
        List<Map<String, Object>> response = statService.getDailyOrders();
        return ResponseEntity.ok(response);
    }
    /**
     * Get daily revenue as time-series data
     * @return List of time-series data [{x: date, y: totalRevenue}]
     */
    @GetMapping("/daily-revenue")
    public ResponseEntity<List<Map<String, Object>>> getDailyRevenue() {
        log.info("Fetching daily revenue statistics...");
        List<Map<String, Object>> response = statService.getDailyRevenue();
        return ResponseEntity.ok(response);
    }

    /**
     * Get monthly revenue as time-series data
     * @return List of time-series data [{x: yyyy-MM, y: totalRevenue}]
     */
    @GetMapping("/monthly-revenue")
    public ResponseEntity<List<Map<String, Object>>> getMonthlyRevenue() {
        log.info("Fetching monthly revenue statistics...");
        List<Map<String, Object>> response = statService.getMonthlyRevenue();
        return ResponseEntity.ok(response);
    }

        @GetMapping("/daily-new-customers")
    public ResponseEntity<List<Map<String, Object>>> getDailyNewCustomers() {
        log.info("Fetching daily new customers statistics...");
        List<Map<String, Object>> response = statService.getDailyNewCustomers();
        return ResponseEntity.ok(response);
    }

    @GetMapping("/monthly-new-customers")
    public ResponseEntity<List<Map<String, Object>>> getMonthlyNewCustomers() {
        log.info("Fetching monthly new customers statistics...");
        List<Map<String, Object>> response = statService.getMonthlyNewCustomers();
        return ResponseEntity.ok(response);
    }


    @GetMapping("/top-brands")
    public ResponseEntity<List<Map<String, Object>>> getTopBrands(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam(defaultValue = "5") int limit) {
        log.info("Fetching top purchased brands from {} to {} with limit {}", startDate, endDate, limit);
        return ResponseEntity.ok(statService.getTopBrands(startDate, endDate, limit));
    }

    @GetMapping("/revenue-by-sku")
    public ResponseEntity<List<Map<String, Object>>> getRevenueBySKU(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        log.info("Fetching revenue by SKU from {} to {}", startDate, endDate);
        return ResponseEntity.ok(statService.getRevenueBySKU(startDate, endDate));
    }

    @GetMapping("/revenue-by-blindbox")
    public ResponseEntity<List<Map<String, Object>>> getRevenueByBlindBox(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        log.info("Fetching revenue by BlindBox from {} to {}", startDate, endDate);
        return ResponseEntity.ok(statService.getRevenueByBlindBox(startDate, endDate));
    }

    @GetMapping("/revenue-by-brand")
    public ResponseEntity<List<Map<String, Object>>> getRevenueByBrand(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        log.info("Fetching revenue by Brand from {} to {}", startDate, endDate);
        return ResponseEntity.ok(statService.getRevenueByBrand(startDate, endDate));
    }

    @GetMapping("/revenue-trend")
    public ResponseEntity<List<Map<String, Object>>> getRevenueTrend(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam(defaultValue = "day") String groupBy) {
        log.info("Fetching revenue trend from {} to {} grouped by {}", startDate, endDate, groupBy);
        return ResponseEntity.ok(statService.getRevenueTrend(startDate, endDate, groupBy));
    }

    @GetMapping("/top-selling-skus")
    public ResponseEntity<List<Map<String, Object>>> getTopSellingSKUs(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam(defaultValue = "5") int limit) {
        log.info("Fetching top selling SKUs from {} to {} with limit {}", startDate, endDate, limit);
        return ResponseEntity.ok(statService.getTopSellingSKUs(startDate, endDate, limit));
    }
}
