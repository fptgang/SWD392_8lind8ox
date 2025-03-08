package com.fptgang.backend.repository;

import com.fptgang.backend.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
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
        SELECT DATE(o.createdAt) AS date, SUM(o.checkoutPrice) AS totalRevenue
        FROM Order o
        GROUP BY DATE(o.createdAt)
        ORDER BY DATE(o.createdAt)
    """)
    List<Object[]> getDailyRevenue();

    // Monthly Revenue
    @Query("""
        SELECT DATE_FORMAT(o.createdAt, '%Y-%m') AS month, SUM(o.checkoutPrice) AS totalRevenue
        FROM Order o
        GROUP BY DATE_FORMAT(o.createdAt, '%Y-%m')
        ORDER BY DATE_FORMAT(o.createdAt, '%Y-%m')
    """)
    List<Object[]> getMonthlyRevenue();

    @Query("""
    SELECT FUNCTION('DATE_FORMAT', o.createdAt, 
        CASE 
            WHEN :groupBy = 'day' THEN '%Y-%m-%d'
            WHEN :groupBy = 'week' THEN '%Y-%u'
            WHEN :groupBy = 'month' THEN '%Y-%m'
            ELSE '%Y-%m-%d'  
        END
    ) AS period, 
    SUM(o.checkoutPrice) AS totalRevenue
    FROM Order o
    WHERE o.createdAt BETWEEN :startDate AND :endDate
    GROUP BY FUNCTION('DATE_FORMAT', o.createdAt, 
        CASE 
            WHEN :groupBy = 'day' THEN '%Y-%m-%d'
            WHEN :groupBy = 'week' THEN '%Y-%u'
            WHEN :groupBy = 'month' THEN '%Y-%m'
            ELSE '%Y-%m-%d'
        END
    )
    ORDER BY MIN(o.createdAt)
""")
    List<Object[]> getRevenueTrend(LocalDateTime startDate, LocalDateTime endDate, String groupBy);



}
