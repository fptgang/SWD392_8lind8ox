package com.fptgang.backend.service;

import com.fptgang.backend.model.OrderStatusHistory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface OrderStatusHistoryService {
    OrderStatusHistory create(OrderStatusHistory orderStatusHistory);

    OrderStatusHistory findById(long id);

    OrderStatusHistory update(OrderStatusHistory orderStatusHistory);

    OrderStatusHistory deleteById(long id);

    Page<OrderStatusHistory> getAll(Pageable pageable, String filter, String search, boolean includeInvisible);

    default Page<OrderStatusHistory> getAll(Pageable pageable, String filter, String search) {
        return getAll(pageable, filter, search, false);
    }

    default Page<OrderStatusHistory> getAll(Pageable pageable, String filter) {
        return getAll(pageable, filter, null, false);
    }
}