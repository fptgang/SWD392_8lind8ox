package com.fptgang.backend.service;

import com.fptgang.backend.model.OrderDetail;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface OrderDetailService {
    OrderDetail create(OrderDetail orderDetail);
    OrderDetail findById(long id);
    OrderDetail update(OrderDetail orderDetail);
    OrderDetail deleteById(long id);
    Page<OrderDetail> getAll(Pageable pageable, String filter, boolean includeInvisible);
    default Page<OrderDetail> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, false);
    }
}