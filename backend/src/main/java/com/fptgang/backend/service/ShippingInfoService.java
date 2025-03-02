package com.fptgang.backend.service;

import com.fptgang.backend.model.ShippingInfo;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface ShippingInfoService {
    ShippingInfo create(ShippingInfo shippingInfo);

    ShippingInfo findById(long id);

    ShippingInfo update(ShippingInfo shippingInfo);

    ShippingInfo deleteById(long id);

    Page<ShippingInfo> getAll(ListParams params);
}