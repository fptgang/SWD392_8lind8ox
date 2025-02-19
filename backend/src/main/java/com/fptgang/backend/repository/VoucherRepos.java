package com.fptgang.backend.repository;

import com.fptgang.backend.model.Voucher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface VoucherRepos extends JpaRepository<Voucher, Long>, JpaSpecificationExecutor<Voucher> {

}
