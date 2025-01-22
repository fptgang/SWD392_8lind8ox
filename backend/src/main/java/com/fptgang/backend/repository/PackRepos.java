package com.fptgang.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.fptgang.backend.model.Pack;

@Repository
public interface PackRepos extends JpaRepository<Pack, Long> , JpaSpecificationExecutor<Pack> {
}
