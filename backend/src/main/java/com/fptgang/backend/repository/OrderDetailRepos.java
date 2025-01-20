package com.fptgang.backend.repository;

import com.fptgang.backend.model.OrderDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderDetailRepos extends JpaRepository<OrderDetail, Long>, JpaSpecificationExecutor<OrderDetail> {
}
