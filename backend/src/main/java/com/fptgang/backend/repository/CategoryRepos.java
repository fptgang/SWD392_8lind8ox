package com.fptgang.backend.repository;

import com.fptgang.backend.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepos extends JpaRepository<Category, Integer> , JpaSpecificationExecutor<Category> {
}
