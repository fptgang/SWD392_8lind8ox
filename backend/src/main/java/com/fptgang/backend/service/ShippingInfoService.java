package com.fptgang.backend.service;

import com.fptgang.backend.model.ShippingInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ShippingInfoService {
    ShippingInfo create(ShippingInfo shippingInfo);

    ShippingInfo findById(long id);

    ShippingInfo update(ShippingInfo shippingInfo);

    ShippingInfo deleteById(long id);

    Page<ShippingInfo> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);

    default Page<ShippingInfo> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }

    default Page<ShippingInfo> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}