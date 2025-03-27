package com.fptgang.backend.service.impl;

import com.fptgang.backend.config.BlindBoxConfig;
import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.Voucher;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.VoucherRepos;
import com.fptgang.backend.service.VoucherService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class VoucherServiceImpl implements VoucherService {

    private final BlindBoxConfig blindBoxConfig;
    private final VoucherRepos voucherRepos;
    private final AccountRepos accountRepos;

    @Autowired
    public VoucherServiceImpl(BlindBoxConfig blindBoxConfig, VoucherRepos voucherRepos, AccountRepos accountRepos) {
        this.blindBoxConfig = blindBoxConfig;
        this.voucherRepos = voucherRepos;
        this.accountRepos = accountRepos;
    }

    @Override
    public Voucher create(Voucher voucher) {
        return voucherRepos.save(voucher);
    }

    @Override
    public Voucher createForCustomerId(long customerId) {
        Account account = accountRepos.findByAccountId(customerId).orElseThrow(
                () -> new RuntimeException("Account not found")
        );
        if(!account.getRole().hasPermission(Account.Role.CUSTOMER)){
            throw new RuntimeException("Account is not a customer");
        }
        Voucher voucher = new Voucher();

        voucher.setState(Voucher.State.AVAILABLE);
        voucher.setAccount(account);
        voucher.setCode(RandomStringUtils.randomAlphanumeric(blindBoxConfig.getDefaultCodeLength()));
        voucher.setDiscountRate(blindBoxConfig.getDefaultDiscountRate());
        voucher.setLimitAmount(blindBoxConfig.getDefaultLimitAmount());
        voucher.setExpiredAt(LocalDateTime.now().plusMonths(blindBoxConfig.getDefaultExpiredMonths()));
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
        if (voucher.getState() != Voucher.State.AVAILABLE) {
            throw new IllegalStateException("Voucher is not in AVAILABLE state");
        }
        voucher.setState(Voucher.State.EXPIRED);
        return voucherRepos.save(voucher);
    }

    @Override
    public Page<Voucher> getAll(ListParams params) {
        var spec = params.<Voucher>toSpec();
        return voucherRepos.findAll(spec, params.getPageable());
    }
}