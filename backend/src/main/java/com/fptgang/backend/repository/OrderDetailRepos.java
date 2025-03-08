package com.fptgang.backend.repository;

import com.fptgang.backend.api.model.Pageable;
import com.fptgang.backend.model.OrderDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderDetailRepos extends JpaRepository<OrderDetail, Long>, JpaSpecificationExecutor<OrderDetail> {

    @Query("""
    SELECT b.name, COUNT(od.orderDetailId) AS totalPurchases
    FROM OrderDetail od
    JOIN od.stockKeepingUnit s
    JOIN s.blindBox bb
    JOIN bb.brand b
    WHERE od.createdAt BETWEEN :startDate AND :endDate
    GROUP BY b.name
    ORDER BY COUNT(od.orderDetailId) DESC
    """)
    List<Object[]> getTopBrands( LocalDateTime startDate,LocalDateTime endDate);

    @Query("""
    SELECT s.name AS skuName, SUM(od.checkoutPrice * od.quantity) AS totalRevenue
    FROM OrderDetail od
    JOIN od.stockKeepingUnit s
    WHERE od.createdAt BETWEEN :startDate AND :endDate
    GROUP BY s.name
    ORDER BY SUM(od.checkoutPrice * od.quantity) DESC
    """)
    List<Object[]> getRevenueBySKU( LocalDateTime startDate, LocalDateTime endDate);

    @Query("""
    SELECT bb.name AS blindBoxName, SUM(od.checkoutPrice * od.quantity) AS totalRevenue
    FROM OrderDetail od
    JOIN od.stockKeepingUnit s
    JOIN s.blindBox bb
    WHERE od.createdAt BETWEEN :startDate AND :endDate
    GROUP BY bb.name
    ORDER BY SUM(od.checkoutPrice * od.quantity) DESC
    """)
    List<Object[]> getRevenueByBlindBox(LocalDateTime startDate, LocalDateTime endDate);

    @Query("""
    SELECT b.name AS brandName, SUM(od.checkoutPrice * od.quantity) AS totalRevenue
    FROM OrderDetail od
    JOIN od.stockKeepingUnit s
    JOIN s.blindBox bb
    JOIN bb.brand b
    WHERE od.createdAt BETWEEN :startDate AND :endDate
    GROUP BY b.name
    ORDER BY SUM(od.checkoutPrice * od.quantity) DESC
    """)
    List<Object[]> getRevenueByBrand( LocalDateTime startDate, LocalDateTime endDate);

    @Query("""
    SELECT s.name AS skuName, SUM(od.quantity) AS totalQuantity
    FROM OrderDetail od
    JOIN od.stockKeepingUnit s
    WHERE od.createdAt BETWEEN :startDate AND :endDate
    GROUP BY s.name
    ORDER BY SUM(od.quantity) DESC
    LIMIT :limit
""")
    List<Object[]> getTopSellingSKUs(LocalDateTime startDate, LocalDateTime endDate, int limit);
}
