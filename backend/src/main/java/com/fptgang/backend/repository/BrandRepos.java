package com.fptgang.backend.repository;

import com.fptgang.backend.model.Brand;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface BrandRepos extends JpaRepository<Brand, Long> , JpaSpecificationExecutor<Brand> {
}
