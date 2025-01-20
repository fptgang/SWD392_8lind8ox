package com.fptgang.backend.repository;

import com.fptgang.backend.model.Image;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ImageRepos extends JpaRepository<Image, Long> , JpaSpecificationExecutor<Image> {
}
