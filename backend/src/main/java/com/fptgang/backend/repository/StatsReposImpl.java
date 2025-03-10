package com.fptgang.backend.repository;

import com.fptgang.backend.model.stats.StringBigDecimalDatapoint;
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
        CONCAT(b.name, ' - ', s.name) AS key,
        SUM(od.finalTotal * od.quantity) AS value
        FROM OrderDetail od
        JOIN od.stockKeepingUnit s
        JOIN s.blindBox b
        WHERE od.createdAt BETWEEN :startDate AND :endDate
        GROUP BY b.name, s.skuId
        ORDER BY SUM(od.finalTotal * od.quantity) DESC
    """;
        return entityManager.createQuery(jpql, StringBigDecimalDatapoint.class)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();
    }
}
