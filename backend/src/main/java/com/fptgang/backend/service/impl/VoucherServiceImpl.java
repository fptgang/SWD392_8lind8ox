package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Voucher;
import com.fptgang.backend.repository.VoucherRepos;
import com.fptgang.backend.service.VoucherService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
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
        Voucher existing = voucherRepos.findById(voucher.getVoucherId())
                .orElseThrow(() -> new IllegalArgumentException("Voucher does not exist"));
        EntityUtil.merge(existing, voucher);
        return voucherRepos.save(existing);
    }

    @Override
    public Voucher deleteById(long id) {
        Voucher voucher = voucherRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Voucher does not exist"));
//        voucher.voucherVisible(false);
        return voucherRepos.save(voucher);
    }

    @Override
    public Page<Voucher> getAll(ListParams params) {
        var spec = params.<Voucher>toSpec();
        return voucherRepos.findAll(spec, params.getPageable());
    }
}