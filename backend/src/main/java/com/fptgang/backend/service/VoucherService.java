package com.fptgang.backend.service;

import com.fptgang.backend.model.Voucher;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface VoucherService {
    Voucher create(Voucher voucher);

    Voucher findById(long id);

    Voucher update(Voucher voucher);

    Voucher deleteById(long id);

    Page<Voucher> getAll(ListParams params);
}