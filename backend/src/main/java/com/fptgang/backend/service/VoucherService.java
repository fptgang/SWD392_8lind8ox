package com.fptgang.backend.service;

import com.fptgang.backend.model.Voucher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface VoucherService {
    Voucher create(Voucher voucher);

    Voucher findById(long id);

    Voucher update(Voucher voucher);

    Voucher deleteById(long id);

    Page<Voucher> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);

    default Page<Voucher> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }

    default Page<Voucher> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}