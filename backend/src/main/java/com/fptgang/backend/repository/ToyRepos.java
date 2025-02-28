package com.fptgang.backend.repository;

import com.fptgang.backend.model.StockKeepingUnit;
import com.fptgang.backend.model.Toy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ToyRepos extends JpaRepository<Toy, Long>, JpaSpecificationExecutor<Toy> {
    Page<Toy> findAll(Specification<Toy> spec, Pageable pageable);
}
