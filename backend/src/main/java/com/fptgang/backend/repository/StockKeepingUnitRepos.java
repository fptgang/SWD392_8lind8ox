package com.fptgang.backend.repository;

import com.fptgang.backend.model.StockKeepingUnit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface StockKeepingUnitRepos extends JpaRepository<StockKeepingUnit, Long>, JpaSpecificationExecutor<StockKeepingUnit> {
}
