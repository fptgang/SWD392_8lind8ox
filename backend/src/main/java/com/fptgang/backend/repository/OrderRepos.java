package com.fptgang.backend.repository;

import com.fptgang.backend.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepos extends JpaRepository<Order, Long>, JpaSpecificationExecutor<Order> {
    // Query to count daily orders
    @Query("""
        SELECT DATE(o.createdAt) AS date, COUNT(o) AS orderCount
        FROM Order o
        GROUP BY DATE(o.createdAt)
        ORDER BY DATE(o.createdAt)
    """)
    List<Object[]> getDailyOrders();

    // Query to sum daily revenue
    @Query("""
        SELECT DATE(o.createdAt) AS date, SUM(o.totalPrice) AS totalRevenue
        FROM Order o
        GROUP BY DATE(o.createdAt)
        ORDER BY DATE(o.createdAt)
    """)
    List<Object[]> getDailyRevenue();

    // Monthly Revenue
    @Query("""
        SELECT DATE_FORMAT(o.createdAt, '%Y-%m') AS month, SUM(o.totalPrice) AS totalRevenue
        FROM Order o
        GROUP BY DATE_FORMAT(o.createdAt, '%Y-%m')
        ORDER BY DATE_FORMAT(o.createdAt, '%Y-%m')
    """)
    List<Object[]> getMonthlyRevenue();
}
