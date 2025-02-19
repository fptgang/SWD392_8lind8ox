package com.fptgang.backend.service.impl;

import com.fptgang.backend.model.ShippingInfo;
import com.fptgang.backend.repository.ShippingInfoRepos;
import com.fptgang.backend.service.ShippingInfoService;
import com.fptgang.backend.service.ShippingInfoService;
import com.fptgang.backend.util.OpenApiHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ShippingInfoServiceImpl implements ShippingInfoService {

    private final ShippingInfoRepos shippingInfoRepos;

    @Autowired
    public ShippingInfoServiceImpl(ShippingInfoRepos shippingInfoRepos) {
        this.shippingInfoRepos = shippingInfoRepos;
    }

    @Override
    public ShippingInfo create(ShippingInfo shippingInfo) {
        return shippingInfoRepos.save(shippingInfo);
    }

    @Override
    public ShippingInfo findById(long id) {
        return shippingInfoRepos.findById(id).orElse(null);
    }

    @Override
    public ShippingInfo update(ShippingInfo shippingInfo) {
        if (shippingInfo.getShippingInfoId() == null) {
            throw new IllegalArgumentException("ShippingInfoage does not exist");
        }
        return shippingInfoRepos.save(shippingInfo);
    }

    @Override
    public ShippingInfo deleteById(long id) {
        ShippingInfo shippingInfo = shippingInfoRepos.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("ShippingInfoage does not exist"));
//        shippingInfo.shippingInfoVisible(false);
        return shippingInfoRepos.save(shippingInfo);
    }

    @Override
    public Page<ShippingInfo> getAll(Pageable pageable, String filter, String search, boolean includeInvisible) {
        var spec = OpenApiHelper.<ShippingInfo>filterToSpec(filter);
        spec = spec.and(OpenApiHelper.searchToSpec(search));
        if (!includeInvisible) {
            spec = spec.and((a, _, cb) -> cb.isTrue(a.get("isVisible")));
        }
        return shippingInfoRepos.findAll(spec, pageable);
    }
}