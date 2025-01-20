package com.fptgang.backend.repository;

import com.fptgang.backend.model.PromotionalCampaign;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PromotionalCampaignRepos extends JpaRepository<PromotionalCampaign, Long>, JpaSpecificationExecutor<PromotionalCampaign> {
}
