package com.fptgang.backend.repository;

import com.fptgang.backend.model.ShippingInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ShippingInfoRepos extends JpaRepository<ShippingInfo, Long>, JpaSpecificationExecutor<ShippingInfo> {

}
