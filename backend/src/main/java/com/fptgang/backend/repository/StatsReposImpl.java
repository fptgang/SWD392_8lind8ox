package com.fptgang.backend.repository;

import com.fptgang.backend.model.stats.StringBigDecimalDatapoint;
import com.fptgang.backend.model.stats.StringIntegerDatapoint;
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
        SELECT
            CONCAT(bb.name, ' - ', s.name) AS key,
            SUM(od.finalTotal * od.quantity) AS value
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        JOIN od.order o
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        AND o.latestStatus = 'COMPLETED'
        GROUP BY bb.name, s.name, s.skuId
        ORDER BY value DESC
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
            MIN(CAST(DATE(o.createdAt) AS string)),
            CAST(COUNT(o.orderId) AS integer)
        )
        FROM Order o
        WHERE o.latestStatus = 'COMPLETED'
        GROUP BY DATE(o.createdAt)
        ORDER BY MIN(DATE(o.createdAt)) ASC
        """;

        return entityManager.createQuery(jpql, StringIntegerDatapoint.class)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getDailyRevenue() {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringBigDecimalDatapoint(
            MIN(CAST(DATE(o.createdAt) AS string)),
            SUM(o.finalTotal)
        )
        FROM Order o
        WHERE o.latestStatus = 'COMPLETED'
        GROUP BY DATE(o.createdAt)
        ORDER BY MIN(DATE(o.createdAt)) ASC
        """;

        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getMonthlyRevenue() {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringBigDecimalDatapoint(
            MIN(CONCAT(CAST(YEAR(o.createdAt) AS string), '-', LPAD(CAST(MONTH(o.createdAt) AS string), 2, '0'))),
            SUM(o.finalTotal)
        )
        FROM Order o
        WHERE o.latestStatus = 'COMPLETED'
        GROUP BY YEAR(o.createdAt), MONTH(o.createdAt)
        ORDER BY YEAR(o.createdAt) ASC, MONTH(o.createdAt) ASC
        """;

        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .getResultList();
    }

    @Override
    public List<StringIntegerDatapoint> getDailyNewCustomers() {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringIntegerDatapoint(
            MIN(CAST(DATE(a.createdAt) AS string)),
            CAST(COUNT(a.accountId) AS integer)
        )
        FROM Account a
        GROUP BY DATE(a.createdAt)
        ORDER BY MIN(DATE(a.createdAt)) ASC
        """;

        return entityManager.createQuery(jpql, StringIntegerDatapoint.class)
                .getResultList();
    }

    @Override
    public List<StringIntegerDatapoint> getMonthlyNewCustomers() {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringIntegerDatapoint(
            MIN(CONCAT(CAST(YEAR(a.createdAt) AS string), '-', LPAD(CAST(MONTH(a.createdAt) AS string), 2, '0'))),
            CAST(COUNT(a.accountId) AS integer)
        )
        FROM Account a
        GROUP BY YEAR(a.createdAt), MONTH(a.createdAt)
        ORDER BY YEAR(a.createdAt) ASC, MONTH(a.createdAt) ASC
        """;

        return entityManager.createQuery(jpql, StringIntegerDatapoint.class)
                .getResultList();
    }

    @Override
    public List<StringIntegerDatapoint> getTopBrands(LocalDateTime startDate, LocalDateTime endDate, int limit) {
        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringIntegerDatapoint(
            b.name,
            CAST(COUNT(od.orderDetailId) AS integer)
        )
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        JOIN bb.brand b
        JOIN od.order o
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        AND o.latestStatus = 'COMPLETED'
        GROUP BY b.name
        ORDER BY COUNT(od.orderDetailId) DESC
        """;

        return entityManager.createQuery(jpql, StringIntegerDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .setMaxResults(limit)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueByBlindBox(LocalDateTime startDate, LocalDateTime endDate) {
        String jpql = """
        SELECT
            bb.name AS key,
            SUM(od.finalTotal * od.quantity) AS value
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        GROUP BY bb.name
        ORDER BY value DESC
        """;

        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueByBrand(LocalDateTime startDate, LocalDateTime endDate) {
        String jpql = """
        SELECT
            b.name AS key,
            SUM(od.finalTotal * od.quantity) AS value
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        JOIN bb.brand b
        JOIN od.order o
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        AND o.latestStatus = 'COMPLETED'
        GROUP BY b.name
        ORDER BY value DESC
        """;

        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();
    }

    @Override
    public List<StringBigDecimalDatapoint> getRevenueTrend(LocalDateTime startDate, LocalDateTime endDate, String groupBy) {
        String dateFormat = switch (groupBy.toLowerCase()) {
            case "week" -> "CONCAT(CAST(YEAR(od.createdAt) AS string), '-W', LPAD(CAST(WEEK(od.createdAt) AS string), 2, '0'))";
            case "month" -> "CONCAT(CAST(YEAR(od.createdAt) AS string), '-', LPAD(CAST(MONTH(od.createdAt) AS string), 2, '0'))";
            case "day" -> "CAST(DATE(od.createdAt) AS string)";
            default -> throw new IllegalArgumentException("Invalid groupBy value: " + groupBy);
        };

        String jpql = """
        SELECT NEW com.fptgang.backend.model.stats.StringBigDecimalDatapoint(
            MIN(%s),
            SUM(od.finalTotal * od.quantity)
        )
        FROM OrderDetail od
        JOIN od.order o
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        AND o.latestStatus = 'COMPLETED'
        GROUP BY %s
        ORDER BY MIN(od.createdAt) ASC
        """.formatted(dateFormat, dateFormat);

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
            CAST(CAST(SUM(od.quantity) AS long) AS integer)
        )
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox bb
        JOIN od.order o
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        AND o.latestStatus = 'COMPLETED'
        GROUP BY bb.name, s.name, s.skuId
        ORDER BY SUM(od.quantity) DESC
        """;

        return entityManager.createQuery(jpql, StringIntegerDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .setMaxResults(limit)
                .getResultList();
    }
}
