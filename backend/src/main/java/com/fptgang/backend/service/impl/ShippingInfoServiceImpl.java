package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.Account;
import com.fptgang.backend.model.ShippingInfo;
import com.fptgang.backend.repository.AccountRepos;
import com.fptgang.backend.repository.ShippingInfoRepos;
import com.fptgang.backend.service.ShippingInfoService;
import com.fptgang.backend.service.params.ListParams;
import com.fptgang.backend.util.EntityUtil;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ShippingInfoServiceImpl implements ShippingInfoService {

    private final ShippingInfoRepos shippingInfoRepos;
    private final AccountRepos accountRepos;

    @Autowired
    public ShippingInfoServiceImpl(ShippingInfoRepos shippingInfoRepos, AccountRepos accountRepos) {
        this.shippingInfoRepos = shippingInfoRepos;
        this.accountRepos = accountRepos;
    }

    @Override
    public ShippingInfo create(ShippingInfo shippingInfo) {
        Account account = accountRepos.getReferenceById(shippingInfo.getAccount().getAccountId());
        shippingInfo = shippingInfoRepos.save(shippingInfo);
        if (account.getDefaultShippingInfo() == null) {
            account.setDefaultShippingInfo(shippingInfo);
            accountRepos.save(account);
        }
        return shippingInfo;
    }

    @Override
    public ShippingInfo findById(long id) {
        return shippingInfoRepos.findById(id).orElse(null);
    }

    @Override
    public ShippingInfo update(ShippingInfo shippingInfo) {
        ShippingInfo existing = shippingInfoRepos.findById(shippingInfo.getShippingInfoId())
                .orElseThrow(() -> new IllegalArgumentException("ShippingInfo does not exist"));
        EntityUtil.merge(existing, shippingInfo);
        return shippingInfoRepos.save(existing);
    }

    @Override
    public ShippingInfo deleteById(long id) {
        ShippingInfo shippingInfo = shippingInfoRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ShippingInfo does not exist"));
//        shippingInfo.shippingInfoVisible(false);
        return shippingInfoRepos.save(shippingInfo);
    }

    @Override
    public Page<ShippingInfo> getAll(ListParams params) {
        var spec = params.<ShippingInfo>toSpec();
        return shippingInfoRepos.findAll(spec, params.getPageable());
    }
}