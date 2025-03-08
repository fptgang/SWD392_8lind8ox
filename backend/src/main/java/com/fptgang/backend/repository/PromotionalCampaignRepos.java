package com.fptgang.backend.repository;

import com.fptgang.backend.model.PromotionalCampaign;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface PromotionalCampaignRepos extends JpaRepository<PromotionalCampaign, Long>, JpaSpecificationExecutor<PromotionalCampaign> {
    @Query("""
        SELECT pc FROM PromotionalCampaign pc
        JOIN pc.blindBoxCampaigns bbc
        WHERE bbc.blindBox.blindBoxId = :blindBoxId
        AND pc.isVisible = TRUE
        AND :currentDate BETWEEN pc.startDate AND pc.endDate
        ORDER BY pc.discountRate DESC
        LIMIT 1
    """)
    PromotionalCampaign findBestOngoingCampaignForBlindBox(@Param("blindBoxId") Long blindBoxId,
                                                           @Param("currentDate") LocalDateTime currentDate);
    @Query("""
        SELECT pc FROM PromotionalCampaign pc
        JOIN pc.blindBoxCampaigns bbc
        JOIN bbc.blindBox bb
        JOIN bb.skus sku
        WHERE sku.skuId = :skuId
        AND pc.isVisible = TRUE
        AND :currentDate BETWEEN pc.startDate AND pc.endDate
        ORDER BY pc.discountRate DESC
        LIMIT 1
    """)
    PromotionalCampaign findBestOngoingCampaignForSku(@Param("skuId") Long skuId,
                                                      @Param("currentDate") LocalDateTime currentDate);
}
