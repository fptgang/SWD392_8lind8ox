package com.fptgang.backend.service;

import com.fptgang.backend.model.Order;
import com.fptgang.backend.service.params.ListParams;
import org.springframework.data.domain.Page;

public interface OrderService {
    Order create(Order order);
    Order findById(long id);
    Order update(Order order);
    Order deleteById(long id);
    Page<Order> getAll(ListParams params);
}