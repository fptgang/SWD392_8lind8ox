package com.fptgang.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.fptgang.backend.model.Package;

@Repository
public interface PackageRepos extends JpaRepository<Package, Long> , JpaSpecificationExecutor<Package> {
}
