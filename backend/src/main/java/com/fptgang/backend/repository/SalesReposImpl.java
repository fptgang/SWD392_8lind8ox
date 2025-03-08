package com.fptgang.backend.repository;

import com.fptgang.backend.model.sales.TrendingProduct;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public class SalesReposImpl implements SalesRepos {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<TrendingProduct> findBlindBoxSales(int days) {
        LocalDateTime startDate = LocalDateTime.now().minusDays(days);

        String jpql = """
    SELECT
        b.brandId as brandId,
        b.name as brandName,
        bb.blindBoxId as blindBoxId,
        bb.name as blindBoxName,
        sku.skuId as skuId,
        sku.name as skuName,
        sku.price as price,
        SUM(od.quantity) as orderCount,
        i.imageUrl as image
    FROM StockKeepingUnit as sku
        JOIN sku.blindBox bb
        JOIN bb.brand b
        JOIN OrderDetail od ON sku.skuId = od.stockKeepingUnit.skuId
        JOIN Order o ON od.order.orderId = o.orderId
        LEFT JOIN Image i ON i.blindBox.blindBoxId = bb.blindBoxId
                          AND i.isVisible = TRUE
                          AND i.imageUrl = (
                              SELECT img.imageUrl FROM Image img
                              WHERE img.blindBox.blindBoxId = bb.blindBoxId
                              AND img.isVisible = TRUE
                              ORDER BY img.imageUrl LIMIT 1
                          )
    WHERE o.createdAt >= :startDate
      AND sku.isVisible = TRUE
      AND bb.isVisible = TRUE
      AND b.isVisible = TRUE
    GROUP BY b.brandId, b.name, bb.blindBoxId, bb.name, sku.skuId, sku.name, sku.price, i.imageUrl
    ORDER BY orderCount DESC
    """;
        return entityManager.createQuery(jpql, TrendingProduct.class)
                .setParameter("startDate", startDate)
                .getResultList();
    }

}
