package com.fptgang.backend.repository;

import com.fptgang.backend.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionRepos extends JpaRepository<Transaction, Long> , JpaSpecificationExecutor<Transaction> {
}
