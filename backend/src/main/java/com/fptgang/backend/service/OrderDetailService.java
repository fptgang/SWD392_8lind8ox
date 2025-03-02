package com.fptgang.backend.service;

import com.fptgang.backend.model.OrderDetail;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface OrderDetailService {
    OrderDetail create(OrderDetail orderDetail);
    OrderDetail findById(long id);
    OrderDetail update(OrderDetail orderDetail);
    OrderDetail deleteById(long id);
    Page<OrderDetail> getAll(ListParams params);
}