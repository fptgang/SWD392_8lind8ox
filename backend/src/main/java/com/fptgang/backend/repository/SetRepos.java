package com.fptgang.backend.repository;

import com.fptgang.backend.model.Set;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SetRepos extends JpaRepository<Set, Long>, JpaSpecificationExecutor<Set> {
}
