package com.fptgang.backend.repository;

import com.fptgang.backend.model.OrderStatusHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderStatusHistoryRepos extends JpaRepository<OrderStatusHistory, Long>, JpaSpecificationExecutor<OrderStatusHistory> {
    @Query("""
    SELECT FUNCTION('DATE_FORMAT', o.createdAt, '%Y-%m-%d') AS createdDate,
           AVG(FUNCTION('TIMESTAMPDIFF', 'HOUR', o.createdAt, osh.createdAt)) AS avgFulfillmentTime
    FROM OrderStatusHistory osh
    JOIN osh.order o
    WHERE osh.state = 'DELIVERED'
    GROUP BY FUNCTION('DATE_FORMAT', o.createdAt, '%Y-%m-%d')
    ORDER BY MIN(o.createdAt)
""")
    List<Object[]> getDailyFulfillmentTime();
}


