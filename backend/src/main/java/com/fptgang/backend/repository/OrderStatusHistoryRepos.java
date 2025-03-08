package com.fptgang.backend.repository;

import com.fptgang.backend.model.OrderStatusHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderStatusHistoryRepos extends JpaRepository<OrderStatusHistory, Long>, JpaSpecificationExecutor<OrderStatusHistory> {
}
