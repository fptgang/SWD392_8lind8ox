package com.fptgang.backend.repository;

import com.fptgang.backend.model.BlindBox;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface BlindBoxRepos extends JpaRepository<BlindBox, Long> , JpaSpecificationExecutor<BlindBox> {
}
