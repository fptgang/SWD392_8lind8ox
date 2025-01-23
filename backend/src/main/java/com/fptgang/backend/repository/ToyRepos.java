package com.fptgang.backend.repository;

import com.fptgang.backend.model.Toy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ToyRepos extends JpaRepository<Toy, Long>, JpaSpecificationExecutor<Toy> {
}
