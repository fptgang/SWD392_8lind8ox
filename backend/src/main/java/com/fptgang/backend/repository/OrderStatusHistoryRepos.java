package com.fptgang.backend.repository;

import com.fptgang.backend.model.OrderStatusHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderStatusHistoryRepos extends JpaRepository<OrderStatusHistory, Long>, JpaSpecificationExecutor<OrderStatusHistory> {
    @Query(value = """
    SELECT DATE(o.created_at) AS createdDate, 
           AVG(TIMESTAMPDIFF(HOUR, o.created_at, osh.created_at)) AS avgFulfillmentTime
    FROM order_status_history osh
    JOIN `order` o ON osh.order_id = o.order_id
    WHERE osh.state = 'DELIVERED'
    GROUP BY createdDate
    ORDER BY createdDate
""", nativeQuery = true)
    List<Object[]> getDailyFulfillmentTime();
}


