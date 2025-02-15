package com.fptgang.backend.repository;

import com.fptgang.backend.model.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AccountRepos extends JpaRepository<Account, Long>, JpaSpecificationExecutor<Account> {
    Optional<Account> findByEmail(String mail);
    Optional<Account> findByAccountId(Long accountId);

    @Query("SELECT DATE_FORMAT(a.createdAt, '%Y-%m-%d') AS date, COUNT(a) " +
            "FROM Account a WHERE a.role = 'CUSTOMER' " +
            "GROUP BY DATE_FORMAT(a.createdAt, '%Y-%m-%d') " +
            "ORDER BY DATE_FORMAT(a.createdAt, '%Y-%m-%d') ASC")
    List<Object[]> getDailyNewCustomers();

    @Query("SELECT DATE_FORMAT(a.createdAt, '%Y-%m') AS month, COUNT(a) " +
            "FROM Account a WHERE a.role = 'CUSTOMER' " +
            "GROUP BY DATE_FORMAT(a.createdAt, '%Y-%m') " +
            "ORDER BY DATE_FORMAT(a.createdAt, '%Y-%m') ASC")
    List<Object[]> getMonthlyNewCustomers();
}
