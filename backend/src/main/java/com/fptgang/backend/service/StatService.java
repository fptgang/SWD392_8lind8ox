package com.fptgang.backend.service;
import java.util.List;
import java.util.Map;

public interface StatService {
    List<Map<String, Object>> getDailyOrders();
    List<Map<String, Object>> getDailyRevenue();
    List<Map<String, Object>> getMonthlyRevenue();
    List<Map<String, Object>> getDailyNewCustomers();
    List<Map<String, Object>> getMonthlyNewCustomers();
}
