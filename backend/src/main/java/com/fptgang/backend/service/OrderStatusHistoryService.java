package com.fptgang.backend.service;

import com.fptgang.backend.model.OrderStatusHistory;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface OrderStatusHistoryService {
    OrderStatusHistory create(OrderStatusHistory orderStatusHistory);

    OrderStatusHistory findById(long id);

    OrderStatusHistory update(OrderStatusHistory orderStatusHistory);

    OrderStatusHistory deleteById(long id);

    Page<OrderStatusHistory> getAll(ListParams params);
}