package com.fptgang.backend.repository.impl;

import com.fptgang.backend.model.stats.StringBigDecimalDatapoint;
import com.fptgang.backend.model.stats.StringIntegerDatapoint;
import com.fptgang.backend.repository.StatsRepos;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public class StatsReposImpl implements StatsRepos {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<StringBigDecimalDatapoint> getRevenueBySKU(LocalDateTime startDate, LocalDateTime endDate) {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringBigDecimalDatapoint(
            CONCAT(bb.name, ' - ', s.name),
            SUM(od.finalTotal)
        )
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        JOIN od.order o
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        GROUP BY bb.name, s.name, s.skuId
        ORDER BY SUM(od.finalTotal) DESC
        """;
        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();
    }

    @Override
    public List<StringIntegerDatapoint> getDailyOrders() {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringIntegerDatapoint(
            CAST(DATE(o.createdAt) AS string),
            CAST(COUNT(DISTINCT o.orderId) AS integer)
        )
        FROM Order o
        WHERE o.latestStatus = 'COMPLETED'
        GROUP BY CAST(DATE(o.createdAt) AS string)
        ORDER BY CAST(DATE(o.createdAt) AS string) ASC
        """;
        return entityManager.createQuery(jpql, StringIntegerDatapoint.class)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getDailyRevenue() {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringBigDecimalDatapoint(
            CAST(DATE(o.updatedAt) AS string),
            SUM(o.finalTotal)
        )
        FROM Order o
        JOIN o.orderStatusHistories osh
        WHERE osh.state = 'COMPLETED'
        GROUP BY CAST(DATE(o.updatedAt) AS string)
        ORDER BY CAST(DATE(o.updatedAt) AS string) ASC
        """;
        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getMonthlyRevenue() {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringBigDecimalDatapoint(
            CONCAT(CAST(YEAR(o.updatedAt) AS string), '-', LPAD(CAST(MONTH(o.updatedAt) AS string), 2, '0')),
            SUM(o.finalTotal)
        )
        FROM Order o
        JOIN o.orderStatusHistories osh
        WHERE osh.state = 'COMPLETED'
        GROUP BY CONCAT(CAST(YEAR(o.updatedAt) AS string), '-', LPAD(CAST(MONTH(o.updatedAt) AS string), 2, '0'))
        ORDER BY MIN(o.updatedAt) ASC
        """;
        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueByBlindBox(LocalDateTime startDate, LocalDateTime endDate) {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringBigDecimalDatapoint(
            bb.name,
            SUM(od.finalTotal)
        )
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        GROUP BY bb.blindBoxId, bb.name
        ORDER BY SUM(od.finalTotal) DESC
        """;
        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueByBrand(LocalDateTime startDate, LocalDateTime endDate) {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringBigDecimalDatapoint(
            b.name,
            SUM(od.finalTotal)
        )
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        JOIN bb.brand b
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        GROUP BY b.brandId, b.name
        ORDER BY SUM(od.finalTotal) DESC
        """;
        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();
    }

    @Override
    public List<StringIntegerDatapoint> getTopSellingSKUs(LocalDateTime startDate, LocalDateTime endDate, int limit) {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringIntegerDatapoint(
            CONCAT(bb.name, ' - ', s.name),
            CAST(COUNT(od.orderDetailId) AS integer)
        )
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        JOIN od.order o
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        GROUP BY s.skuId, bb.name, s.name
        ORDER BY COUNT(od.orderDetailId) DESC
        """;
        return entityManager.createQuery(jpql, StringIntegerDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .setMaxResults(limit)
                .getResultList();
    }
}
