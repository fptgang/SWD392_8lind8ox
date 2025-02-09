package com.fptgang.backend.repository;

import com.fptgang.backend.model.Slot;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SlotRepos extends JpaRepository<Slot, Long>, JpaSpecificationExecutor<Slot> {
}

