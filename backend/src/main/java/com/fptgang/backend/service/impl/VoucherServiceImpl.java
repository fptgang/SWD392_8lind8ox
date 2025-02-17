package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Voucher;
import com.fptgang.backend.repository.VoucherRepos;
import com.fptgang.backend.service.VoucherService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class VoucherServiceImpl implements VoucherService {

    private final VoucherRepos voucherRepos;

    @Autowired
    public VoucherServiceImpl(VoucherRepos voucherRepos) {
        this.voucherRepos = voucherRepos;
    }

    @Override
    public Voucher create(Voucher voucher) {
        return voucherRepos.save(voucher);
    }

    @Override
    public Voucher findById(long id) {
        return voucherRepos.findById(id).orElse(null);
    }

    @Override
    public Voucher update(Voucher voucher) {
        if (voucher.getVoucherId() == null) {
            throw new IllegalArgumentException("Voucherage does not exist");
        }
        return voucherRepos.save(voucher);
    }

    @Override
    public Voucher deleteById(long id) {
        Voucher voucher = voucherRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Voucherage does not exist"));
//        voucher.voucherVisible(false);
        return voucherRepos.save(voucher);
    }

    @Override
    public Page<Voucher> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<Voucher>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return voucherRepos.findAll(spec, pageable);
    }
}